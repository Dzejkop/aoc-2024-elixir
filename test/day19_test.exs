defmodule Day19Test do
  use ExUnit.Case, async: true

  test "parse available towles" do
    available = "r, wr, b, g, bwu, rb, gb, br"
    exp = ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]

    assert exp == Day19.parse_available_towels(available)
  end

  test "parse designs" do
    designs = """
    brwrr
    bggr
    gbbr
    """

    exp = ["brwrr", "bggr", "gbbr"]

    assert exp == Day19.parse_designs(designs)
  end

  test "is design possible" do
    towels = ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]

    # towels =
    #   Day19.parse_available_towels(
    #     "ubb, rrgrgg, uurbgr, uuwugg, ugb, wwru, rwguru, bgg, grrbrr, wug, gbwru, wrw, wwbwu, ru, rur, gugr, bggu, burbb, ugbb, buggw, rrwr, bugbug, wgrubw, brw, wbuuwug, bggbugu, ugbwwr, bgwbbuw, uwrg, rwg, buwuwwb, gbb, wurbwbg, gurgwbr, ubgg, rbg, rburwwu, ugr, grb, urb, ruurb, wbrubbw, bwb, uwbubwb, uwbwgg, bwuu, gbu, wwugu, rruwg, bbubr, gbwur, wwgu, uwu, wguw, urbg, rgw, ubrrw, ggu, uuurrr, grw, rgu, ugu, grgu, buggg, wrwrb, uwguw, bwwg, grrurru, u, wgg, wgrgbg, gbr, burrur, wb, bug, rrwurrg, wu, www, gr, rbwwbr, g, gubr, bgubr, bwbgwu, bub, uwgw, wbuuurbg, bbwg, uwub, uwuwur, gugg, guubgg, gu, rrwru, gubb, wubw, urw, uuuubggw, bbr, wbr, gwbu, gwwr, ubu, ggw, rb, burbubb, wgb, rr, bbw, wrbrg, gwbr, wwur, rrwwuwg, bgr, rbbwg, uwrugb, ugbwbb, rru, ugw, wuugur, gur, buuu, bb, grwg, uwrgguug, rbrrrr, rgbru, rbrgbw, buru, rbu, wgwub, wbuuwg, uwrgbu, gwubbbgb, uw, ruu, ruw, bgbbb, brubbwgb, ggrbrb, ggbwgb, bggg, wuub, urrg, bgwrbg, rwr, wbbwww, wgr, ugg, bur, urr, wrr, brb, bwrwrbb, wwrwbww, bguwru, grgwb, urur, ugwrwg, gwrgww, bwgr, uwr, rbugrww, bbu, wgwbwgw, wbuur, brwwbggw, gww, brwgw, ugrggr, bbgg, gbw, wubuuwu, brrbb, grgrw, ruww, wrg, wrbwg, wgwbrb, rrrugw, gug, rg, wubb, gbgggrug, rrr, gwgw, wuwbrw, gwwrrw, rbbg, wwr, bgbgb, bwg, bwrug, gbbw, gbug, wwub, wrru, bwggwru, wuw, wrbgr, gru, bwbuwu, rwgbgg, ub, buwr, wwb, ggugww, ur, uwugw, uuu, rgbb, bgugb, uwwb, ubw, uuwwr, wwugwu, uuw, grr, wgrrgb, rubg, rbrww, ugugwrg, ggg, wrwbuug, rburg, bbrw, bru, rwgw, rrrgg, bgwr, gbg, grww, gbwu, rwrg, ggbw, uwuug, bbgr, r, gbgrwr, bwrgu, rbggw, uu, rgur, bgug, rwu, wg, brguw, bgb, wurbgub, gbgw, gwww, bgrgu, wubbwrgr, wub, wbrgw, brg, bbrg, bbb, ugww, ggb, ubru, grwrwu, bwu, wrrw, gruub, rbr, uwgru, ubwrbw, gb, rbru, wrwbwu, ruburu, rww, rrgrurbr, uww, wwuuwwur, rurrg, rrb, gw, brgw, ubrb, bbgu, gggbgwbr, gugb, rbrbrwg, gbbg, gurur, wurru, rwwggub, grubrb, bbur, gguub, uruu, urwgrwbu, bbg, rrg, wbg, gurwu, guggg, gub, wuu, buwrb, wgbw, bbrb, wurr, bburwbw, buwbu, rwb, ubrbg, urwrwbgr, wugub, gwug, wgrwuggb, bbwgbb, gwb, guw, guu, wru, uug, ubrwguww, wgu, bu, uwg, ggbbwwwg, rgg, rwgg, uwbgu, wuugw, urrgw, uugbwgu, bbuu, rggb, ggru, bbrwwr, bugbgbu, wur, ggwb, wgw, wbw, ww, buuuw, rrbr, wwbwbbw, ruuwuu, urwbb, rbgur, uwb, bww, rwbbw, rgbuwgb, bwguw, bw, buu, ggr, wr, rubbw, rbuu, rbuuwr, uwuubb, uuuw, gwr, rrwgwbgu, bgw, wwg, bgbwrb, rub, wruw, wubu, ubggrg, wuwwgbg, guwwbgw, rrurgrw, rgurw, rbb, bbbw, bwur, bwr, rwruww, ubr, wguug, br, gwu, wrrug, guub, uru, rbgbu, gwrub, wbwwbww, wbgug, rgr, bruw, gwg, wbbwwg, ubgbwwb, ubbrrr, ggburw, wbwwww, wbb, rubru, brrbwu, ruuwu, buw, ugwrgbu, rgb, grg, grrwwrr, bwbb, ugbg, gburg, gggu, grwww, ggggu, wwu, wuggb, rrug, ubg, grgg, rwbbrg, wrurubug, wrb, grubu, ubbb, grrurww, rug, ubgr, wbrgb, ug, uwgr, b, rbbrb, rgwb, gwrwwruu, bgrrbwb, ubwb, urwu, wgwrg, gugguuu, wubbbruw, burg, uub, brwb, wbu, brurg, bg, grwwrgw, uur, brrgg"
    #   )

    assert Day19.possible?("brwrr", towels)
    assert Day19.possible?("bggr", towels)
    assert Day19.possible?("gbbr", towels)
    assert Day19.possible?("rrbgbr", towels)
    assert not Day19.possible?("ubwu", towels)
    assert Day19.possible?("bwurrg", towels)
    assert Day19.possible?("brgr", towels)
    assert not Day19.possible?("bbrgwb", towels)
    # assert not Day19.possible?("ubwrrrwwuuuburubwgugbwwwuurwwuuwwurwruggugwwrwwburrw", towels)

    assert not Day19.impossible?("brwrr", towels)
    assert not Day19.impossible?("bggr", towels)
    assert not Day19.impossible?("gbbr", towels)
    assert not Day19.impossible?("rrbgbr", towels)
    assert Day19.impossible?("ubwu", towels)
    assert not Day19.impossible?("bwurrg", towels)
    assert not Day19.impossible?("brgr", towels)
    assert Day19.impossible?("bbrgwb", towels)
  end
end
