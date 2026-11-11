"""Custom Kitty Tab Bar"""

from kitty.fast_data_types import Screen, get_options, split_into_graphemes, wcswidth
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

TAB_WIDTH = 28


def centered(text: str, width: int) -> str:
    if width <= 0:
        return ""
    text = " ".join(
        "".join(" " if ord(c) < 32 or 127 <= ord(c) < 160 else c for c in text).split()
    )
    if wcswidth(text) > width:
        parts, used = [], 0
        for grapheme in split_into_graphemes(text):
            size = max(0, wcswidth(grapheme))
            if used + size > width - 1:
                break
            parts.append(grapheme)
            used += size
        text = "".join(parts) + "…"
    padding = width - max(0, wcswidth(text))
    left = padding // 2
    return " " * left + text + " " * (padding - left)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if extra_data.for_layout:
        extra_data.tab_count = index
        end = before + max(0, min(TAB_WIDTH, max_tab_length, screen.columns - before))
        screen.cursor.x = end
        return end

    count = extra_data.tab_count
    number_width = len(str(count))
    gap = 1 if screen.columns >= count * 2 - 1 else 0
    separator = gap if index > 1 else 0
    # Budget for pills and connectors together
    available = screen.columns - gap * (count - 1)
    width = max(
        0,
        min(TAB_WIDTH, max(1, available // count), screen.columns - before - separator),
    )
    end = before + separator + width
    if not width:
        return before

    opts = get_options()
    # Base16 palette
    background = int(draw_data.default_bg)
    ink, line = int(opts.color18), int(opts.color20)
    surface = (
        int(opts.selection_background or opts.color8)
        if tab.is_active
        else int(opts.color8)
    )
    accent = int(opts.color4) if tab.is_active else line
    icon = ""
    if tab.needs_attention:
        accent, icon = int(opts.color1), "!"
    elif tab.has_activity_since_last_focus and not tab.is_active:
        accent, icon = int(opts.color3), "•"

    def draw(text: str, foreground: int, bg: int) -> None:
        screen.cursor.fg, screen.cursor.bg = as_rgb(foreground), as_rgb(bg)
        screen.draw(text)

    if separator:
        draw("─", line, background)

    badge = f"{icon} {index}"
    badge_width = wcswidth(icon) + 1 + number_width
    body_width = width - badge_width - 3
    if body_width < 4:
        # Keep crowded bars legible
        if width >= number_width + 2:
            label = badge if width >= badge_width + 2 else str(index)
            draw("", accent, background)
            draw(centered(label, width - 2), ink, accent)
            draw("", accent, background)
        else:
            draw(centered(str(index), width), accent, surface)
    else:
        draw("", accent, background)
        draw(centered(badge, badge_width), ink, accent)
        draw("", accent, surface)
        draw(
            " " + centered(tab.title, body_width - 2) + " ",
            int(opts.foreground),
            surface,
        )
        draw("", surface, background)
    screen.cursor.fg = screen.cursor.bg = 0
    return end
