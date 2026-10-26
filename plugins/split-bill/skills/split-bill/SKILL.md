---
name: split-bill
description: Split a restaurant or bar bill (dividir la cuenta) between people from a photo of the receipt (ticket). Use when the user shares a receipt image and says who ordered what, or asks to regroup people or for the final message of a split in progress. Needs both the receipt and who ordered what; expenses without a restaurant receipt belong in a spreadsheet.
license: MIT
---

# Split a restaurant bill

## Workflow

### 1. Read the receipt
Extract from the image: venue name, date, and the full list of items with quantity, unit price (if any) and line total. Also note the final printed **Total**: it is the value everything gets reconciled against.

Copy prices and product names exactly as printed. Before assigning anything, add up the line totals: they must equal the printed Total. A mismatch here means a misread line, so reread the image or ask about the unreadable value (step 3).

### 2. Match each person's order to the receipt items
The user describes who ordered what, usually in casual language and with possible typos (e.g. "tenderá maracuyá" probably means "Tiras de Pollo" + "Nestea Maracuyá").
- Interpret each description and map it to the exact receipt item.
- If one drink or dish has several units on the receipt (e.g. "3 Nestea Maracuyá") and several people ordered it, deduct units as you assign them.

### 3. Resolve ambiguities with questions
Ask instead of assuming. Use the button-based question tool (`ask_user_input_v0` on claude.ai, `AskUserQuestion` in Claude Code) whenever:
- An ordered item does not specify its variant (e.g. "burger" when the receipt has Angus single, Angus bacon and Chicken).
- A receipt item nobody mentioned (e.g. the large water nobody claimed).
- Units of an item are left over or missing after assigning everything mentioned.
- A value on the receipt is blurry or missing (date, venue name, a price).
- It is unclear whether people join an existing group or form a new one.
- The subtotals do not match the Total and you cannot find why.

Move on to the final calculation only once every receipt line is assigned to someone.

### 4. Group people
By default, each person is an individual entry. If the user asks to put several people in a group (in one message or across several, e.g. "put X and Y in a group" and then "now Z too"):
- Reorganize automatically: the final message always reflects the latest grouping, not the history of how it was built.
- A group can keep growing with later messages ("now David and Pilar" join the same group or form a new one, as the user asks).
- Ask how each group splits its subtotal among its members: equal shares, or each pays their own items. Ask every time a group is closed, not only the first time.

### 5. Reconcile against the Total
Before giving the final answer, add up all subtotals (groups + individuals) and compare against the printed receipt Total. If it does not match, check which item was misassigned, duplicated or left unassigned. Hold the final message until the sum is exact.

### 6. Final message
Plain text only (no files or artifacts unless the user explicitly asks). Write it in the user's language. Structure:

```
🧾 [VENUE NAME] · [DATE] · Total: [TOTAL]€

**Group N: [names]**
- Person: item1 (price) + item2 (price) = **subtotal€**
- ...
- **Group N subtotal: XX,XX€**

**Individual**
- Person: item1 (price) + item2 (price) = **subtotal€**

**TOTAL: XX,XX€** ✅
```

Format rules:
- Groups come first, in the order they were created or mentioned; individuals go last.
- Every item shows its price in parentheses, exactly as on the receipt.
- The final ✅ appears only if the sum actually matches the receipt total: it is the visual confirmation that it was checked.

If the user corrects an assignment after the final message, recalculate the whole block (groups + individuals + total) and show the full message again.
