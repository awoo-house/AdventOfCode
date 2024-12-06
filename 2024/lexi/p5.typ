= Day 5 Advent of Code 2024

Problem 5 is about reordering pages within a manual.

The sample input was given like

```
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13
```

Which can be read like:

  "Page 47 must come before page 53"
  "Page 97 must come before page 13"
  "Page 97 must come before page 61"

...etc.

The second part of the problem asks:

"Given a list of pages that are out of order and the rules for ordering them, what is the correct order of the pages?"

This can be encoded as a system of inequalities, where each page is a variable and the rules are constraints on the variables. 

Let's walk through an example. Sample input is given:

```
97,13,75,29,47
```

The rules that are relevant to these pages are:

```
97|13
97|47
75|29
29|13
97|29
47|13
75|47
97|75
47|29
75|13
```

The goal is to find the correct order of the pages. If we encode the pages as variables, where those variables represent the index of the page in the correct order:

```
  [o1, o2, o3, o4, o5]
```

Then, replacing 97 with o1, 13 with o2, etc., we can encode the rules as constraints:
```
o1 < o2
o1 < o5
o3 < o4
o4 < o2
o1 < o4
o5 < o2
o3 < o5
o1 < o3
o5 < o4
o3 < o2
```

And also, base constraints:

```
1 <= o1 != o2 != o3 != o4 != o5 <= 5
```