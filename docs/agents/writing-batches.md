# 写作批：从毕业到成书的操作口径

这份文档是**配方**，不是判据。它管四件事：批票怎么写、审读怎么起、并发批怎么合、书级冷读什么时候翻 `final`。判据一律不在本文件里，去真源读。

| 住哪 | 是什么 |
| --- | --- |
| [`docs/adversarial-review.md`](../adversarial-review.md) | 判据、角度↔栏、出口表、举证纪律、质检表 |
| [`docs/adr/0002`](../adr/0002-file-layout-and-numbering.md) | 文件形态、编号、批的大小、并发口径 |
| [`docs/adr/0005`](../adr/0005-full-autopilot-mode.md) | 全程托管、status 流转、失灵探针、阈值与重定点 |
| [`docs/reviewer/`](../reviewer/) | **跑一次审读要粘的东西**：人格 + 四段任务 + 三份输出格式 |
| [`docs/agents/branching.md`](branching.md) | 分支、worktree、对账与合并 |
| 本文件 | 顺序、目录、命令、谁在什么时候写哪个文件 |
| 票的结论评论 | 读数（**批级记录**）——读数不进文件 |

## 一、批是什么

一个**批** = 一张写作票 + 一个会话 + 一个分支，3–5 条**同轴**灵感（ADR-0002「并发」、ADR-0005 第六条）。

- **条数 3–5 由审读质量定**：一个审读员在一个 fresh context 里判得完、判词还引得出原句的量。第一张批取 3（见 §七）。
- **并发：跨轴并行、轴内串行**。默认同时 2 批，硬顶 4 批，**硬规则是不许两批同轴**。
- **在飞批数怎么数**：地图上 `open` 且**已认领**的写作票。开新批前数一遍：要 < 2，且主轴与自己不同。要到 4 批，必须是阶梯四级各一批。
- 批只碰自己号段内的文件，别的什么都不碰（§二）。

## 二、批票模板

票是地图的 child（正文顶部 `Part of #1`），标签 `wayfinder:task`。下面整段抄进 issue 正文，尖括号是填空。

````markdown
Part of #1

## 这批写什么

轴：<轴>（<阶梯级>）｜号段：<001–003>｜<3> 条

| 号 | 文件 | leading word | 卡（选料票已建好） |
|---|---|---|---|
| 001 | `book/001-<slug>.md` | <leading word> | `book/001-<slug>.card.md` |

## 谁写谁锁定

本批**只**建/改这些文件，别人不许碰：

- **新建** `book/<nnn>-<slug>.md`：纯正文，首行 H1 = 中文标题，**无 front matter**
- **改** `book/<nnn>-<slug>.card.md` 的**后两栏**（`增量价值` / `何时别用`）——前两栏与 `status: draft` 是选料票填的，别动

**不碰**：`book/index.md`、`book/graveyard.md`、别人号段的任何文件、`docs/`、`proto/`、`notes/`

分支 `write/<号段>`，worktree `/tmp/wt-<号段>`，起点 `main`。一批一个写者。

## 选料票转来的条

- <号>：<这一条要在正文里落地的边界 / 反直觉点 / 已定的举证基线>

## 口径

- 400–900 字/篇（**汉字 + 拉丁词**，计数对象＝稿件正文，含**行为示意**块）；导言类 1200–1500 字
- 骨架七槽：hook → 场景 → 天真做法为什么不够 → 组合机制 → 行为示意 → 何时不适用 → 回扣 leading word
- 术语首次出现**就地一句注解**（ADR-0001 / `GLOSSARY.md`）；形成新术语就追加进 `GLOSSARY.md`（追加式，见 §五第 2 条）

## 收工动作（AFK，不许停）

1. **作者自查**（#5 的分关）：成稿后判 `增量价值` / `何时别用`，落点是卡的**后两栏**
2. **建材料目录**：§三第 1 步
3. **起四路审读**：§三第 2 步（角度一 / 角度二 / 冷读，隔离 run，互不可见）
4. **合议 + 补判**：§三第 3 步
5. **翻 `status: reviewed`**：§三第 4 步（起草会话翻 `draft → reviewed` 允许；`reviewed → final` 不许）
6. **合回 `main`**：§五
7. **写批级记录**：本票的结论评论，必填行见 §四
8. **烧号**：§五第 4 步（收尾提交，打在 `main` 上）
9. 全稿每篇都 `reviewed` 了 → 立刻在地图上开「书级冷读」票：§六
````

## 三、送审 runbook

变量：`R` = 仓库主 worktree，`W` = 本批 worktree，`N` = 号段，`M` = 材料目录。

### 1. 建材料目录

**隔离靠目录，不靠纪律。** 角度一二与冷读拿的不是同一批材料，所以两个目录：`a12/` 有卡与判据，`c/` **只有正文**。

```bash
R=/var/opt/md
W=/tmp/wt-001-003
N=001-003
M=/tmp/review-$N
SHA=$(git -C "$W" rev-parse HEAD)     # 材料指纹：进批级记录
rm -rf "$M"; mkdir -p "$M/a12/稿件" "$M/a12/卡" "$M/a12/判据/adr" "$M/c"

for f in 001-append-only-by-contract 002-the-effect-is-outside-the-line 003-forgetting-as-visibility; do
  cp "$W/book/$f.md" "$M/a12/稿件/"
  cp "$W/book/$f.md" "$M/c/"                       # 冷读：只有正文
  cp "$W/book/$f.card.md" "$M/a12/卡/"
done
cp "$R/docs/adversarial-review.md" "$M/a12/判据/"
cp "$W/GLOSSARY.md"                "$M/a12/判据/"
cp "$R"/docs/adr/000{1,3,5}-*.md   "$M/a12/判据/adr/"

# 同轴已毕业条索引：取 index 表里主轴匹配、且不在本批号段内的行
awk -F'|' -v a='记忆与延续' '$4 ~ a && $2 !~ /-(001|002|003)\.md/ {print $2, $3, $4}' \
  "$W/book/index.md" > "$M/a12/同轴已毕业.md"
# 再把这些条的卡的 `增量价值` / `反直觉` 两行接在后面（卡里没填的写「（未填）」）。
# 3–5 条的批，手工即；不要喂全文——索引级比较就够了。
```

冷读目录里**没有** `判据/`：可粘贴的任务段自己带着三行输出格式，而「只读正文」是 ADR-0003 的原话。

### 2. 起四路 run

四条并行、各自 fresh context、模型**同一个**（角度差异必须来自角度，不能来自模型；模型名记进批级记录）。报告写在 `$M/` 这一层——**不在任何 run 的 cwd 里**，所以没有一路读得到别人的报告。

```bash
P="$R/docs/reviewer"

(cd "$M/a12" && pi -p --system-prompt "$(cat $P/persona.md)" --tools read \
   --no-session --no-skills --no-context-files --model <provider/id> \
   "$(cat $P/task-a1.md $P/format-axis-1.md)") > "$M/report-a1.md" 2>"$M/err-a1.log" &
(cd "$M/a12" && pi -p --system-prompt "$(cat $P/persona.md)" --tools read \
   --no-session --no-skills --no-context-files --model <provider/id> \
   "$(cat $P/task-a2.md $P/format-axis-1.md)") > "$M/report-a2.md" 2>"$M/err-a2.log" &
(cd "$M/c"   && pi -p --system-prompt "$(cat $P/persona.md)" --tools read \
   --no-session --no-skills --no-context-files --model <provider/id> \
   "$(cat $P/task-cold.md $P/format-cold.md)") > "$M/report-cold.md" 2>"$M/err-cold.log" &
wait
```

`--no-skills --no-context-files` 不是洁癖：它们挡住技能与 `AGENTS.md` 的渗入。**判据由材料带进去，不靠 run 去读仓库**——所以 `a12/判据/` 必须齐。

### 3. 合议与补判

父会话读四份报告，逐篇给总判（**过 / 补 / 砍**）：轴一（角度一 + 角度二，逐栏）与轴二（冷读）**分开报**，一轴过、另一轴挂是常态，合并会掩盖。

- **补判**：只重跑**判「补」的那一个角度**，材料目录里把改过的稿件 / 卡换成新版，重记 `SHA`。**至多三次**，第三次仍不过按砍处理。不做全文复审。
- 判「补」的栏**不许用「小改、仍弱」结案**：要么改到能过，要么走该栏出口。
- **砍**（烧号）只有一条硬路径：差异点写不出可观察的行为差别；加上补判三次仍不过。

### 4. 翻 `draft → reviewed`

逐篇只改**总判「过」**的卡：`status: draft` → `reviewed`（起草会话翻这一下是允许的）。总判「砍」的篇，在**分支上**把稿件与卡一起删掉（删除随分支走，见 §五第 4 条）。

## 四、批级记录（票的结论评论）

读数的家是票，不另开文件（ADR-0002「地图与票」）。

````markdown
## 批级记录 · <号段>（<轴>）

- **材料指纹**：稿件 + 卡的 `write/<号段>` @ `<sha>`；审读模型 `<provider/id>`
- **审读总判**：<001 过 / 002 补（`何时别用`，补 1 轮）/ 003 砍>
- **零发现批**：有 / **零**（连续第 <n> 批）
- **轴内重复**：本批 <n> 条（该轴累计 <x>/3）
- **砍路径①（差异点退化成形容词）**：**触发 / 未触发**
- **烧号**：<哪几个号 + 收尾提交 sha；没有写「无」>
- **跨轴共用机制**：<本批各条与哪个轴共用机制——供书级冷读配平>
- **本票不适用的信号**：终读翻盘率（书级，首次终读后重定点）、遗弃名单空转（选料票读数）
````

`砍路径①` **每批都写**，不只第一张——零值本身是读数。#15 把它的落点钉在第一张写作批，不代表后面的批可以不记。

`零发现批` 的判据（不要数「砍」）：**一整批没有任何一栏被判不过或无法判定，且冷读三行都给不出问题**。`终读翻盘率` 与 `遗弃名单空转` 恒不适用——**不写空行**，一行带过，别把它们挂到不可能发生的阶段上（ADR-0005 Consequences 的那条教训）。

## 五、合并与收尾

1. **合回时点**：总判「过」并翻 `reviewed` 之后。顺序照 [`docs/agents/branching.md`](branching.md)：`git fetch` → 落后就在**分支上**对账（`git checkout main -- <分支没碰的路径>`；两边都碰的按更新的决定取）→ `git merge --no-ff` 进 `main`。
2. **唯一可能共享的文件是 `GLOSSARY.md`**（新术语）：追加式，冲突时两边都留、同词去重；合并后**逐条读 `git diff` 的 `-` 行**。
3. 合完 `git worktree remove /tmp/wt-<号段>`，**分支保留不删**（远端 ref 绝不删）。
4. **烧号 = 收尾提交，打在 `main` 上**，不在批的分支上：删 `book/index.md` 那一行、往 `book/graveyard.md` 追加（编号 / 曾用标题 / 弃因），提交。稿件与卡的删除**已经随分支合进来了**。
   为什么不在分支上改：`index.md` 与 `graveyard.md` 是共享文件，而合并是串行的——收尾提交打在 `main` 上，就把并发的批排成了队，正好保住 ADR-0002 那句「写作批绝不碰 `index.md`」。

   > 这条是 ADR-0002 没写的那半句：「弃号烧掉」与「写作批不碰 index」两句并存时，谁写 index 没人交代。它只落在这里，**不改 ADR**；若后续判它动了 ADR 的实质，另开票。
   >
   > `book/graveyard.md` 现在还不存在——**第一次烧号时新建**。

5. 这批不做的事：不重排 `index.md` 的次序，不动别的轴，不碰 `docs/`。

## 六、书级冷读与翻 `final`

**触发三条同时成立**，缺一条就别开：

1. 全稿每篇 `status: reviewed`，没有 `draft` 残留；
2. `book/index.md` 的次序**已定为送审次序**（次序定稿本身不在本文件里——它是地图上另一片雾）；
3. 没有在飞的写作批。

**谁开票、谁跑**：**不是任何一批的起草会话**。最后一个把批翻成 `reviewed` 的收尾动作里，若发现三条成立，就地在地图上开一张「书级冷读 · 第一版」的票（`wayfinder:task`、`Part of #1`、AFK、不认领），body 写明材料 sha；由**下一会话**认领执行。跑这次冷读的会话就是「书级冷读那一会话」——它读报告、处理报告、翻 `status: final`，它不是任何一篇的起草者，所以自己签字的禁令不破。

1. **建材料目录**（只喂编排事实与正文，不喂卡、不喂票、不喂笔记）：

```bash
R=/var/opt/md; M=/tmp/review-book
rm -rf "$M"; mkdir -p "$M/全稿" "$M/判据/adr"
awk -F'|' '$2 ~ /\.md/ {gsub(/ /,"",$2); print $2}' "$R/book/index.md" \
  | while read -r f; do cp "$R/book/$f" "$M/全稿/"; done      # 只取 index 表里列到的条目文件
cp "$R/book/index.md"              "$M/"
cp "$R/docs/adversarial-review.md" "$M/判据/"
cp "$R/GLOSSARY.md"                "$M/判据/"
cp "$R"/docs/adr/000{1,3,5}-*.md   "$M/判据/adr/"
```

2. **一个 run**：

```bash
P="$R/docs/reviewer"
(cd "$M" && pi -p --system-prompt "$(cat $P/persona.md)" --tools read \
   --no-session --no-skills --no-context-files --model <provider/id> \
   "$(cat $P/task-book-cold.md $P/format-book-cold.md)") > "$M/report.md" 2>"$M/err.log"
```

3. **处理报告**（在 `main` 上，独立提交）：该烧的烧号（同 §五第 4 步）、该返工的返工、该补轴的补轴。**烧了会破坏轴配额或阶梯的不烧**——摘进终读包。次序重排若要做，在这一步之前做完，因为冷读读的次序就是送审次序。
4. 处理动了稿 → **只复读受影响的轴**（不全文重读）；复读无异议才继续。
5. **翻 `final`**：分支 `review/whole-book`，逐卡把 `status: reviewed` 改成 `final`（**只动 `*.card.md` 的 front matter**），合回 `main`。
6. **交人**：终读包 = **全稿 + 一页遗弃名单**（编号 / 曾用标题 / 弃因）+ 报告里 `留给终读裁：` 的那几行。**不装卡**。终读之后不再有大改，只烧号与修补被烧伤的承接处。

报告与处理结果住**那张票的结论评论**（同「批级记录住票里」）。

## 七、这张配方自己的第一张批

第一张写作批是这份 runbook 与 §四那几行的**首次真跑**，没有前例可照——所以取允许区间的下限：**3 条**（`001–003`，轴「记忆与延续」，阶梯 L1）。跑完把 §四的读数留在票里当对照：批级三信号的重定点是**第 4 张写作批**的批级记录（ADR-0005 第四条），在此之前首发值继续生效。
