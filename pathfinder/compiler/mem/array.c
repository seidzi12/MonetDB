/* -*- c-basic-offset:4; c-indentation-style:"k&r"; indent-tabs-mode:nil -*- */

/**
 * @file
 *
 * Typed, dynamic arrays: accessing an element at an out-of-bounds index
 * does not yield an error but lets the array grow as needed.
 *
 * Basic interface:
 *  - PFarray (s,sl)    create new array with elements of s bytes length each
 *                      and initially sl slots, set array ``append index'' to 0
 * - #PFarray_at (a, i) address of ith element in array a (a grows as needed)
 * - #PFarray_last (a)  ``append index'': where to append to this array (r/w)
 *
 * More complex operations may be constructed using
 * the basic interface, e.g.,
 * - append one element e to array a (available as #PFarray_add):
 *   @code
     *(PFarray_at (a, PFarray_last (a)++) = e
     @endcode
 *
 * - append n elements e1, ..., en, to array a (available as #PFarray_nadd):
 *   @code
     i = PFarray_last (a);
     (void) PFarray_at (a, i);
     (void) PFarray_at (a, i + (n - 1));
     PFarray_last(a) += n;
     *(PFarray_at (a, i)) = e1; ...; *(PFarray_at (a, i + (n - 1))) = en;
     @endcode
 *
 *
 * Copyright Notice:
 * -----------------
 *
 * The contents of this file are subject to the Pathfinder Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://monetdb.cwi.nl/Legal/PathfinderLicense-1.1.html
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.  See
 * the License for the specific language governing rights and limitations
 * under the License.
 *
 * The Original Code is the Pathfinder system.
 *
 * The Original Code has initially been developed by the Database &
 * Information Systems Group at the University of Konstanz, Germany and
 * the Database Group at the Technische Universitaet Muenchen, Germany.
 * It is now maintained by the Database Systems Group at the Eberhard
 * Karls Universitaet Tuebingen, Germany.  Portions created by the
 * University of Konstanz, the Technische Universitaet Muenchen, and the
 * Universitaet Tuebingen are Copyright (C) 2000-2005 University of
 * Konstanz, (C) 2005-2008 Technische Universitaet Muenchen, and (C)
 * 2008-2009 Eberhard Karls Universitaet Tuebingen, respectively.  All
 * Rights Reserved.
 *
 * $Id$
 */

#include "pf_config.h"
#include "pathfinder.h"

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>
#include <stdlib.h>

#include "array.h"

/* PFmalloc, PFrealloc */
#include "mem.h"
#include "oops.h"

#ifndef NDEBUG
/* switch to turn debug printing
   of memory reallocations on/off */
bool debug_memory;
#endif

/**
 * Create a fresh dynamic array, prepared to hold elements of byte size
 * @c s each.
 *
 * @param s size (in bytes) of array elements
 * @return fresh dynamic array (or 0 in case of errors)
 */
PFarray_t *
PFarray_ (size_t s, unsigned int slots, bool clear)
{
  PFarray_t *a;
  size_t nbytes;

  if (s == 0)
      PFoops (OOPS_FATAL, "array payload is empty");

  a = (PFarray_t *) PFmalloc (sizeof (PFarray_t));

  a->bound = slots + 1; /* allocate one more slot */
  a->esize = s;
  a->clear = clear;

  nbytes  = a->bound*a->esize;
  a->base = PFmalloc (nbytes);

  if (clear)
      memset (a->base, 0, nbytes);

  /* 0 indicates emptiness (see macro PFarray_empty ()) */
  a->appi  = 0;

  return a;
}

/**
 * Compute the address of element position @c i of array @c a (if @c i
 * is an out-of-bounds index, grow @a as needed).
 *
 * @param a array
 * @param i array index
 * @return array element address (or 0, in case of errors)
 */
void *
#ifndef NDEBUG
PFarray_at_ (PFarray_t *a, unsigned int i,
             const char *file, const char *func, const int line)
#else
PFarray_at (PFarray_t *a, unsigned int i)
#endif
{
  size_t nbytes;

  assert (a);

  if (i >= a->bound) {
#ifndef NDEBUG
      if (debug_memory &&
          /* The following functions have been checked and the initial
             sizes appear to be bigger than the average sizes. */
          strcmp (func, "la_cse") != 0 &&
          strcmp (func, "PFarray_nadd") != 0 &&
          strcmp (func, "add_subdom") != 0)
          PFlog ("array not big enough"
                 " in %s, %s(), line %d"
                 " (required slots: %i; got: %i)",
                 file, func, line, i+1, a->bound);
#endif

      if (i >= 2 * a->bound)
          /* out-of-bounds index access,
           * grow array such that index position i becomes valid
           */
          nbytes = (i + 1) * a->esize;
      else
          /* amortize reallocation costs for small chunks */
          nbytes = 2 * a->bound*a->esize;

      assert(a->base);
      a->base = PFrealloc (a->base, a->bound*a->esize, nbytes);

      if (a->clear)
          memset ((void*)((char*) a->base + (a->bound*a->esize)),
                  0,
                  nbytes - (a->bound*a->esize));

      a->bound = nbytes / a->esize;
  }

  /* return address of requested index position i */
  /* (explicite casting to avoid void-pointer
      arithmetic, which as some compilers don't like) */
  return (void*)((char*)(a->base) + i * a->esize);
}

/**
 * Prepare array @c a for an @c n-fold element append and return the
 * ``append address''.  Repeated application of this function advances
 * the append position.
 *
 * @param a array
 * @param n number of elements to be added
 * @return address of array element to hold the first new element
 *  (the other n-1 element addresses directly follow the first)
 */
void *
PFarray_nadd (PFarray_t *a, unsigned int n)
{
  unsigned int i;

  assert (a);
  assert (n);

  i = PFarray_last (a);

  /* pretend to access first (i) and last (i + n - 1) new array
   * element position (such that everything between first and last
   * index gets allocated as well), the new append index is just after
   * the last new element position (i + n)
   */
  (void) PFarray_at (a, i);
  (void) PFarray_at (a, i + (n - 1));

  PFarray_last (a) += n;

  /* return address of first index position i */
  /* (explicite casting to avoid void-pointer
      arithmetic, which as some compilers don't like) */
  return (void*)((char*)(a->base) + i * a->esize);
}

/**
 * Append printf-style formatted string material to dynamic array @c a
 * (array @c a is expected to be an array holding character(-sized)
 * elements).
 *
 * @param a   array
 * @param fmt printf-style format string
 * @return number of characters actually appended (or -1 in case of errors)
 */
int
PFarray_printf (PFarray_t *a, const char *fmt, ...)
{
    int ret;
    va_list args;

    va_start (args, fmt);
    ret = PFarray_vprintf (a, fmt, args);
    va_end (args);

    return ret;
}

/**
 * Append printf-style formatted string material to dynamic array @c a
 * (array @c a is expected to be an array holding character(-sized)
 * elements).
 *
 * @param a   array
 * @param fmt printf-style format string
 * @param mat variable-length list of printing arguments
 * @return number of characters actually appended (or -1 in case of errors)
 */
int
PFarray_vprintf (PFarray_t *a, const char *fmt, va_list mat)
{
    va_list tmp;
    size_t len = BUFSIZ;
    char  *try = malloc(len);
    int   nchars;

    /* make sure this is an array holding charater(-sized) elements */
    assert (a && a->esize == sizeof (char));

    /* try to ``print'' the material into a mini-array.  this will
     * probably fail but we are told the size of what would have been
     * printed if we had enough space available if the implementation
     * of vsnprint is C99-compliant.  in case it isn't, we loop with
     * ever larger buffers until we do know the size.
     */
    va_copy(tmp, mat);
    while ((nchars = vsnprintf (try, len, fmt, tmp)) < 0) {
        len *= 2;
        try = realloc(try, len);
        va_copy(tmp, mat);
    }
    free(try);


    /* now that we know the actual size, print the formatted material
     * into the array (+ 1 for the trailing '\0' printed by vsprintf)
     */
    (void) vsnprintf ((char *) PFarray_nadd (a, nchars + 1), nchars + 1, fmt, mat);


    /* overwrite trailing '\0' on next print to this array */
    PFarray_last (a)--;

    /* return the number of characters printed (excluding the trailing '\0') */
    return nchars;
}

/**
 * Array concatenation.  The entries of a2 are inserted
 * into a1 (at end).
 *
 * @attention NB. this makes sense only if both arrays have entries of
 *   the same size.
 *
 * @param a1 first array (will grow)
 * @param a2 second array (unchanged)
 * @return array a1 with entries of a2 appended
 */
PFarray_t *
PFarray_concat (PFarray_t *a1, PFarray_t *a2)
{
    unsigned l1, l2;

    assert (a1 && a2);
    assert (a1->esize == a2->esize);

    l1 = PFarray_last (a1);
    l2 = PFarray_last (a2);

    if (l2) {
        PFarray_nadd (a1, l2);
        memcpy (PFarray_at (a1, l1), PFarray_at (a2, 0), l2 * a2->esize);
    }

    return a1;
}

/**
 * Array copy.  The entries of input are inserted
 * into a new array output.
 *
 * @param input input array (unchanged)
 * @return array @a output with a copy of the entries of @a input
 */
PFarray_t *
PFarray_copy (PFarray_t *input)
{
    assert (input);

    unsigned size = PFarray_last (input);
    PFarray_t *output = PFarray_ (input->esize, input->bound, input->clear);

    if (size) {
        PFarray_nadd (output, size);

        memcpy (PFarray_at (output, 0),
                PFarray_at (input, 0),
                size * input->esize);
    }
    return output;
}

/**
 * Delete the last element from an array.
 *
 * @param a   array
 */
void PFarray_del(PFarray_t *a)
{
    if (PFarray_empty (a))
        PFoops (OOPS_FATAL, "deleting from an empty array");
    else
        /* decrement the current array append index */
        (a->appi)--;
}

#ifndef NDEBUG
/**
 * Look up the environment variable only once.
 */
void PFarray_init (void)
{
    debug_memory = getenv("PF_DEBUG_MEMORY") != NULL;
}
#endif

/* vim:set shiftwidth=4 expandtab: */
