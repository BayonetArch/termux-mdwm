/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar           = 1;        /* 0 means no bar */
static const int topbar            = 1;        /* 0 means bottom bar */
static const char *fonts[]         = { "JetBrainsMonoNerdFont-SemiBold:size=22" }; /* Reduced font size for mobile */
static const char dmenufont[]      = "JetBrainsMonoNerdFont-SemiBold:size=16";     /* Reduced font size for mobile */

/* Everforest Dark palette */
static const char col_black[]       = "#2b3339"; /* background */
static const char col_gray[]        = "#7a8478"; /* gray */
static const char col_white[]       = "#d3c6aa"; /* foreground */
static const char col_green[]       = "#a7c080"; /* green */
static const char col_blue[]        = "#7fbbb3"; /* blue/aqua */
static const char col_yellow[]      = "#dbbc7f"; /* yellow */
static const char col_red[]         = "#e67e80"; /* red */
static const char col_purple[]      = "#d699b6"; /* purple */

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_white, col_black, col_gray },
	[SchemeSel]  = { col_black, col_green, col_blue },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Firefox",  NULL,       NULL,       1 << 1,       0,           -1 }, /* Send Firefox to tag 2 */
	{ "Alacritty", NULL,      NULL,       0,       0,           -1 }, /* Send Alacritty to tag 2 */
	{ "qutebrowser", NULL,    NULL,       0,            0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask /* Use Alt as the mod key */
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_black, "-nf", col_white, "-sb", col_green, "-sf", col_black, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *quitcmd[]  = { "pkill", "dwm", NULL };
static const char *browsercmd[] = { "firefox", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      spawn,          {.v = browsercmd } },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_q,      spawn,          {.v = quitcmd } },
	{ MODKEY,                       XK_f,      togglefullscr,  {0} },
	{ MODKEY,                       XK_g,      togglefloating, {0} },
	
	/* vim-like window navigation (fixed to correct next/prev focus) */
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } }, /* Focus next window */
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } }, /* Focus previous window */
	{ MODKEY|ShiftMask,                       XK_h,      setmfact,       {.f = -0.05} }, /* Decrease master area size */
	{ MODKEY|ShiftMask,                       XK_l,      setmfact,       {.f = +0.05} }, /* Increase master area size */
	
	/* vim-like window position controls */
	{ MODKEY|ShiftMask,             XK_d,      pushdown,       {0} },
	{ MODKEY|ShiftMask,             XK_u,      pushup,         {0} },
	
	/* tag controls */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
