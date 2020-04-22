/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0.  If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Copyright 1997 - July 2008 CWI, August 2008 - 2020 MonetDB B.V.
 */

/*
 * Environment variables
 * =====================
 *
 * The processing setting of the SQL front-end can collect information
 * for postprocessing and debugging by setting a flag
 * using the SQL construct:
 * SET <variable>=<string>
 * SET <variable>=<boolean>
 * SET <variable>=<int>
 *
 * The SQL engine comes with a limited set of environment variables
 * to control its behavior.
 * The 'debug' variable takes an integer and sets the Mserver global
 * debug flag. (See MonetDB documentation.)
 *
 * By default all remaining variables are stored as strings and
 * any type analysis is up to the user. The can be freely used by the
 * SQL programmer for inclusion in his queries.
 *
 * The limited number of built-in variables defined above are
 * strongly typed the hard way.
 * Moreover, they have a counterpart representation in the
 * MVC structure to ease inspection during query processing.
 *
 * The variables can be retrieved using the table producing function var();
 */

#include "monetdb_config.h"
#include "sql_env.h"
#include "sql_semantic.h"
#include "sql_privileges.h"
#include "mal_exception.h"

str
#ifdef HAVE_HGE
sql_update_var(mvc *m, sql_schema *s, const char *name, char *sval, hge sgn)
#else
sql_update_var(mvc *m, sql_schema *s, const char *name, char *sval, lng sgn)
#endif
{
	if (strcmp(s->base.name, "sys") == 0) {
		if (strcmp(name, "debug") == 0) {
#ifdef HAVE_HGE
			assert((hge) GDK_int_min <= sgn && sgn <= (hge) GDK_int_max);
#else
			assert((lng) GDK_int_min <= sgn && sgn <= (lng) GDK_int_max);
#endif
			m->debug = (int) sgn;
		} else if (strcmp(name, "current_schema") == 0) {
			if (!mvc_set_schema(m, sval))
				throw(SQL,"sql.update_var", SQLSTATE(3F000) "Schema (%s) missing\n", sval);
		} else if (strcmp(name, "current_role") == 0) {
			if (!mvc_set_role(m, sval))
				throw(SQL,"sql.update_var", SQLSTATE(42000) "Role (%s) missing\n", sval);
		} else if (strcmp(name, "current_timezone") == 0) {
#ifdef HAVE_HGE
			assert((hge) GDK_int_min <= sgn && sgn <= (hge) GDK_int_max);
#else
			assert((lng) GDK_int_min <= sgn && sgn <= (lng) GDK_int_max);
#endif
			m->timezone = (int) sgn;
		} else if (strcmp(name, "cache") == 0) {
#ifdef HAVE_HGE
			assert((hge) GDK_int_min <= sgn && sgn <= (hge) GDK_int_max);
#else
			assert((lng) GDK_int_min <= sgn && sgn <= (lng) GDK_int_max);
#endif
			m->cache = (int) sgn;
		}
	}
	return NULL;
}

int
sql_create_env(mvc *m, sql_schema *s)
{
	list *res, *ops;

	res = sa_list(m->sa);
	list_append(res, sql_create_arg(m->sa, "name", sql_bind_subtype(m->sa, "varchar", 1024, 0), ARG_OUT));
	list_append(res, sql_create_arg(m->sa, "value", sql_bind_subtype(m->sa, "varchar", 2048, 0), ARG_OUT));

	/* add function */
	ops = sa_list(m->sa);
	mvc_create_func(m, NULL, s, "env", ops, res, F_UNION, FUNC_LANG_SQL, "sql", "sql_environment", "CREATE FUNCTION \"sys\".\"env\"() RETURNS TABLE(\"name\" varchar(1024), \"value\" varchar(2048)) EXTERNAL NAME \"sql\".\"sql_environment\";", FALSE, FALSE, TRUE);

	res = sa_list(m->sa);
	list_append(res, sql_create_arg(m->sa, "schema", sql_bind_localtype("str"), ARG_OUT));
	list_append(res, sql_create_arg(m->sa, "name", sql_bind_localtype("str"), ARG_OUT));
	list_append(res, sql_create_arg(m->sa, "type", sql_bind_localtype("str"), ARG_OUT));
	list_append(res, sql_create_arg(m->sa, "value", sql_bind_localtype("str"), ARG_OUT));

	/* add function */
	ops = sa_list(m->sa);
	mvc_create_func(m, NULL, s, "var", ops, res, F_UNION, FUNC_LANG_SQL, "sql", "sql_variables", "CREATE FUNCTION \"sys\".\"var\"() RETURNS TABLE(\"schema\" string, \"name\" string, \"type\" string, \"value\" string) EXTERNAL NAME \"sql\".\"sql_variables\";", FALSE, FALSE, TRUE);
	return 0;
}
