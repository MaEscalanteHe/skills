---
name: split-bill
description: Split a restaurant bill (dividir la cuenta) between several people from a photo of the receipt or ticket. Use it ALWAYS when the user uploads an image of a restaurant or bar receipt AND describes who ordered what (even informally, with typos, or across several messages). Also use it when the user asks to group or regroup people already assigned in an earlier split in the same conversation, or asks for the "final message" of a split in progress. Do not use it when only the receipt is uploaded without any detail of who ordered what, or to split expenses that do not come from a restaurant receipt (use a spreadsheet for that).
license: MIT
---

# Split a restaurant bill

Read a restaurant receipt (from an image) and assign each item to the person or group who ordered it, always reconciling against the printed Total.

## Workflow

### 1. Read the receipt
Extract from the image: venue name, date, and the full list of items with quantity, unit price (if any) and line total. Also note the final printed **Total**: it is the value everything gets reconciled against.

### 2. Match each person's order to the receipt items
The user describes who ordered what, usually in casual language and with possible typos (e.g. "tenderá maracuyá" probably means "Tiras de Pollo" + "Nestea Maracuyá"). Your job:
- Interpret each description and map it to the exact receipt item.
- If a person orders something generic (e.g. "burger") and the receipt has several variants (Angus single, Angus bacon, Chicken), ask which one instead of picking.
- If one drink or dish has several units on the receipt (e.g. "3 Nestea Maracuyá") and several people ordered it, deduct units as you assign them.

### 3. Resolve ambiguities with questions
Ask instead of assuming. Use the button-based question tool (`ask_user_input_v0` on claude.ai, `AskUserQuestion` in Claude Code) for cases such as:
- An ordered item does not specify its variant (e.g. "burger" when there are Angus single, Angus bacon and Chicken).
- A receipt item nobody mentioned (e.g. the large water nobody claimed).
- Units of an item left over or missing after assigning everything mentioned.

Move on to the final calculation only once every receipt line is assigned to someone.

### 4. Group people
By default, each person is an individual entry. If the user asks to put several people in a group (in one message or across several, e.g. "put X and Y in a group" and then "now Z too"):
- Reorganize automatically: the final message always reflects the latest grouping, not the history of how it was built.
- A group can keep growing with later messages ("now David and Pilar" join the same group or form a new one, as the user asks; if it is unclear whether it is the same group or a new one, ask).
- Ask how each group splits its subtotal among its members: equal shares, or each pays their own items. Ask every time a group is closed, not only the first time.
- People not grouped stay individual.

### 5. Reconcile against the Total, ALWAYS
Before giving the final answer, add up all subtotals (groups + individuals) and compare against the printed receipt Total. If it does not match:
- Check which item was misassigned, duplicated or left unassigned.
- Hold the final message until the sum is exact. If there is a mismatch you cannot resolve, ask the user.

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

## Notes
- Take prices and product names literally from the receipt (keep the original casing and format if reasonable, or normalize to standard capitalization), using only product names printed on it.
- If the receipt image is blurry or a value is missing (date, venue name, an unreadable price), ask before assuming any value.
- If the user corrects an assignment after the final message, recalculate the whole block (groups + individuals + total) and show the full message again, never just the changed fragment.
