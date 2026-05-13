---
name: swift-translations
description: Interactive skill to guide the developer step-by-step to create and translate a new key for Localizable.xcstrings.
---

# Interactive Translation Generator (FHK Standard)

## Core Protocol
You must guide the developer through an interactive flow to create a translation key. 
**CRITICAL:** You must ask ONLY ONE question per turn. Never ask multiple questions or request all information at once.

## Target File
- The file is located at the absolute path: `/Users/fredyleon/Documents/fintechKids/Localizable.xcstrings`
- Do not search for this file globally. Open it directly when needed.

## Interactive Flow

Follow these steps strictly:

### Step 1: Request Key Name
- Ask the user: *"¿Cuál será el nombre de la clave (key) que quieres crear?"*
- Wait for the user's response before proceeding.

### Step 2: Validate & Request Text
- Once you receive the key, open the file `/Users/fredyleon/Documents/fintechKids/Localizable.xcstrings` and check if the key already exists.
- **If it exists:** Inform the developer and stop the process.
- **If it does NOT exist:** Keep the key in memory and ask: *"¿Cuál es el texto en español que quieres traducir a EN, FR, e IT?"*
- Wait for the user's response.

### Step 3: Present Draft & Save
- Translate the Spanish text into:
  - ENGLISH (EN)
  - SPANISH (ES)
  - ITALIAN (IT) -> **Strict Rule:** Always use the language code "IT" for Italian.
  - FRENCH (FR)
- **Formatting Rules for Translations:**
  - Convert all translated texts strictly to **lowercase**.
  - Remove all **accents** and special characters (e.g., "metas" instead of "mestas", "cancelar" instead of "cancelar", etc.).
- Show the draft JSON structure to the user.
- If approved, insert the key into `/Users/fredyleon/Documents/fintechKids/Localizable.xcstrings` following the standard `.xcstrings` format and confirm the success.

---

## Output Checklist
- [ ] Only 1 question asked per turn
- [ ] Checked for existing keys in `/Users/fredyleon/Documents/fintechKids/Localizable.xcstrings`
- [ ] Translated to EN, ES, IT (Italian), and FR
- [ ] Translations formatted in lowercase and without accents
- [ ] Saved successfully to the file