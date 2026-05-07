# //正文 之前的模板/导言区
# 正文里的标题行，比如 = ...、== ...
# #prob-box[...]、#star-prob-box[...]、#mutistar-prob-box[...]

# python quest.py learn.typ
# python quest.py learn.typ -o output.typ
# python quest.py learn.typ --in-place

# 默认会生成同目录下的 原文件名_quest.typ。

from __future__ import annotations

import argparse
import re
from pathlib import Path


BODY_MARKER = "//正文"
HEADING_RE = re.compile(r"^\s*=+\s+")
# 匹配 #prob-box[...]、#prob-box([...], label: <...>) 以及任意前缀版本
BOX_START_RE = re.compile(r"^\s*#(?:\w+-)*prob-box\s*(?P<opener>\[|\()")
DOLLAR_RE = re.compile(r"(?<!\\)\$")


def split_preamble_and_body(text: str) -> tuple[str, str]:
    marker_index = text.find(BODY_MARKER)
    if marker_index == -1:
        return "", text

    body_start = text.find("\n", marker_index)
    if body_start == -1:
        return text, ""

    return text[: body_start + 1], text[body_start + 1 :]


def collect_box_block(lines: list[str], start: int, opener: str) -> tuple[list[str], int]:
    block: list[str] = []
    closer = "]" if opener == "[" else ")"
    depth = 0
    started = False
    i = start

    while i < len(lines):
        line = lines[i]
        block.append(line)

        search_from = line.find(opener) if not started else 0
        for char in line[search_from:]:
            if char == opener:
                depth += 1
                started = True
            elif char == closer and started:
                depth -= 1

        i += 1
        if started and depth <= 0:
            break

    return block, i


def trim_body(body: str) -> str:
    lines = body.splitlines(keepends=True)
    kept: list[str] = []
    i = 0
    in_math = False

    while i < len(lines):
        line = lines[i]

        if not in_math and HEADING_RE.match(line):
            kept.append(line)
        elif match := BOX_START_RE.match(line):
            block, i = collect_box_block(lines, i, match.group("opener"))
            kept.extend(block)
        elif not line.strip():
            if kept and kept[-1].strip():
                kept.append("\n")

        if len(DOLLAR_RE.findall(line)) % 2 == 1:
            in_math = not in_math

        i += 1

    result = "".join(kept)
    result = re.sub(r"\n{3,}", "\n\n", result)
    return result.lstrip("\n")


def extract_questions(text: str) -> str:
    preamble, body = split_preamble_and_body(text)
    trimmed_body = trim_body(body)
    return preamble + trimmed_body


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="保留 Typst 文档中的标题和题目盒子，删除正文解答等内容。"
    )
    parser.add_argument("input", help="输入的 .typ 文件路径")
    parser.add_argument(
        "-o",
        "--output",
        help="输出文件路径；若不提供，则默认写入原文件同目录下的 <文件名>_quest.typ",
    )
    parser.add_argument(
        "--in-place",
        action="store_true",
        help="直接覆盖输入文件",
    )
    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        parser.error(f"输入文件不存在: {input_path}")

    output_text = extract_questions(input_path.read_text(encoding="utf-8"))

    if args.in_place:
        output_path = input_path
    elif args.output:
        output_path = Path(args.output)
    else:
        output_path = input_path.with_name(f"{input_path.stem}_quest.typ")

    output_path.write_text(output_text, encoding="utf-8")
    print(f"已生成: {output_path}")


if __name__ == "__main__":
    main()
