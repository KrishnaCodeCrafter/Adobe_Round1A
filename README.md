
# 🧠 Adobe India Hackathon 2025 - Round 1A Submission

### Challenge Theme: **Connecting the Dots Through Docs**

---

## 🔍 Overview

This project is our submission for **Round 1A** of Adobe India's Hackathon 2025. The challenge requires building a **PDF structure extractor** that processes raw PDF documents and outputs a structured JSON containing:

- The **document title**
- A hierarchy of **headings**: H1, H2, and H3
- Associated **page numbers**

This structured outline enables smarter downstream use cases like semantic search, recommendation systems, and contextual understanding of document structure.

---

## 🚀 Features

- 📄 Accepts any PDF (up to 50 pages)
- 🧠 Extracts title using **metadata**, **visual analysis**, and **content heuristics**
- 🏷 Detects **headings** and classifies them into H1, H2, H3 using:
  - Font size normalization
  - Boldness detection
  - Position & semantic rules
- ⚙️ Fully containerized using Docker (amd64)
- 🔌 Works **offline** without internet or cloud APIs
- 💡 Clean, modular codebase for easy extension in Round 1B

---

## 📂 Input/Output Format

### Input

Place one or more `.pdf` files inside the `input` folder (mapped to `/app/input` inside Docker).

### Output

Each output JSON is saved with the same base filename in the `output` folder (mapped to `/app/output`). Example output:
```json
{
  "title": "Understanding AI",
  "outline": [
    { "level": "H1", "text": "Introduction", "page": 1 },
    { "level": "H2", "text": "What is AI?", "page": 2 },
    { "level": "H3", "text": "History of AI", "page": 3 }
  ]
}
```

---

## 🛠 Approach

### 1. **Title Extraction**
- Try extracting title from PDF metadata.
- If not found, scan the first page for prominent text lines.
- Use font-size analysis as a fallback to locate the largest text that meets certain filters.

### 2. **Heading Extraction**
- If the PDF has a Table of Contents (ToC), parse it directly.
- If not, scan all pages using `PyMuPDF`:
  - Extract all text spans with their font sizes and formatting.
  - Normalize font sizes to determine heading levels.
  - Apply filters to avoid page numbers, dates, or decorative text.

### 3. **Robustness**
- Ignores dates, page footers/headers, and repeated non-informative text.
- Avoids false positives using semantic filters (e.g., avoids all-lowercase, purely numeric, or URL-like strings).

---

## 📦 Dependencies

Installed within the Docker image:

- `PyMuPDF` (`fitz`)
- `PyPDF2`
- `pdfplumber`

---

## 🐳 Docker Instructions

### 🧱 Build the Image

```bash
docker build --platform linux/amd64 -t pdf-outline-extractor:round1a .
```

### ▶️ Run the Solution

```bash
docker run --rm \
  -v $(pwd)/input:/app/input \
  -v $(pwd)/output:/app/output \
  --network none \
  pdf-outline-extractor:round1a
```

✅ All input PDFs inside `input/` will be processed, and corresponding `.json` files will be written to `output/`.

---

## 📎 Constraints Handled

| Constraint               | Status    |
|-------------------------|-----------|
| ≤ 10 sec for 50-page PDF| ✅         |
| Model size ≤ 200MB      | ✅ (No ML) |
| No internet access      | ✅         |
| CPU-only                | ✅         |
| Works offline           | ✅         |

---

## 📑 File Structure

```
.
├── main.py                # Core logic for title & heading extraction
├── Dockerfile             # Dockerfile for offline containerized execution
├── input/                 # Input PDFs directory (to be mounted)
├── output/                # Output JSONs directory (to be mounted)
└── README.md              # You're reading it!
```

---

## 💡 Notes

- Headings are **not** hardcoded; logic is content-agnostic.
- No web or API calls are made.
- Can handle complex and multilingual documents to a reasonable degree.
- Modular design makes it reusable for Round 1B.

---

## 🛑 Don'ts (As Per Problem Statement)

- ❌ No file-specific hacks  
- ❌ No hardcoded headings  
- ❌ No external API/internet usage  
- ❌ No GPU/large model usage  

---
