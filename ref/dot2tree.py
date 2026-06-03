import sys, re

edges = {}
nodes = set()

# 標準入力からDOTの依存エッジ (A -> B) を抽出
for line in sys.stdin:
    m = re.search(r'"([^"]+)"\s*->\s*"([^"]+)"', line)
    if m:
        u, v = m.groups()
        edges.setdefault(u, []).append(v)
        nodes.add(u)
        nodes.add(v)

# どこからも依存されていないパッケージ（ルート）を特定
incoming = {v for u in edges for v in edges[u]}
roots = sorted(list(nodes - incoming))

def print_tree(node, prefix=""):
    children = edges.get(node, [])
    for i, child in enumerate(children):
        is_last = (i == len(children) - 1)
        pointer = "└── " if is_last else "├── "
        print(f"{prefix}{pointer}{child}")
        extension = "    " if is_last else "│   "
        print_tree(child, prefix + extension)

# ツリーの描画
for root in roots:
    print(root)
    print_tree(root)
