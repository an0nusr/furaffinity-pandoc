-- Pandoc Custom Reader for FurAffinity-style BBCode
-- By anonusr, 2022
--
-- Note that this code cannot process alignment or color operations.
-- 
-- Based on the Pandoc custom reader template, with a custom LPEG
-- grammar for parsing BBCode

local P, S, R, Cf, Cc, Ct, V, Cs, Cg, Cb, B, C, Cmt =
  lpeg.P, lpeg.S, lpeg.R, lpeg.Cf, lpeg.Cc, lpeg.Ct, lpeg.V,
  lpeg.Cs, lpeg.Cg, lpeg.Cb, lpeg.B, lpeg.C, lpeg.Cmt

local whitespacechar = S(" \t\r\n")
local wordchar = (1 - whitespacechar)
local spacechar = S(" \t")
local newline = P"\r"^-1 * P"\n"
local blanklines = newline * (spacechar^0 * newline)^1
local endline = newline - blanklines

local header_start = P"[h" * (R"17" / tonumber) * "]" 
local header_end = P"[/h" * R"17" * "]"

local cmds = (P"sup" + P"sub" + (P"h" * R"17") + P"quote" 
  + (P"url" * (P"=" * (1 - P"]" - whitespacechar)^1)^0) 
  + P"b" + P"i" + P"u" + P"s")

-- Note - inspiration on tags was taken from here: https://gist.github.com/soulik/f9ef4b4dd2dadf066b07
-- Additional helpful notes are here: https://stackoverflow.com/questions/27009411/how-to-do-lookahead-properly-with-lpeg
-- And here: http://lua-users.org/wiki/LpegTutorial
-- And here: https://tug.org/tug2019/slides/slides-menke.pdf (comparison between peg and lpeg)

function urlHelper(t)
  local url = ""
  local text = ""
  if t[1]:match('^=') then 
    url = string.sub(t[1], 2)
    text = t[2]
  else 
    url = t[1]
    text = t[1]
  end

  return pandoc.Link(text, url)
end

-- Grammar
G = P{ "Pandoc",
  Pandoc = Ct(V"Block"^0) / pandoc.Pandoc;
  Block = blanklines^0 * (V"Header" + V"BlockQuote" + V"Para") ;
  Para = Ct(V"Inline"^1) / pandoc.Para;
  Inline = V"Emph" + V"Strong" + V"Underline" + V"Strike" + V"Super" + V"Sub" + V"Url"
    + V"Str" + V"Space" + V"SoftBreak";
  Str = (1 - whitespacechar - V"cmd")^1 / pandoc.Str;
  Space = spacechar^1 / pandoc.Space;
  SoftBreak = endline / pandoc.SoftBreak;

  cmd = P"[" * P"/"^-1 * (cmds) * P"]"; -- don't treat these as part of strings
  
  -- block items
  Header = header_start * Ct(V"Inline"^1) * header_end / pandoc.Header;
  BlockQuote = P"[quote]" * Ct(V"Para"^1) * P"[/quote]" / pandoc.BlockQuote;

  -- inline items
  Emph = P"[i]" * Ct(V"Inline"^1) * P"[/i]" / pandoc.Emph;
  Strong = P"[b]" * Ct(V"Inline"^1) * P"[/b]" / pandoc.Strong;
  Underline = P"[u]" * Ct(V"Inline"^1) * P"[/u]" / pandoc.Underline;
  Strike = P"[s]" * Ct(V"Inline"^1) * P"[/s]" / pandoc.Strikeout;
  Super = P"[sup]" * Ct(V"Inline"^1) * P"[/sup]" / pandoc.Superscript;
  Sub = P"[sub]" * Ct(V"Inline"^1) * P"[/sub]" / pandoc.Subscript;
  Url = Ct(P"[url" * C((P"=" * (1 - whitespacechar - "]")^1)^0) * P"]" * C(V"Inline"^1) * P"[/url]") / urlHelper;
  
}

function Reader(input)
  return lpeg.match(G, input)
end