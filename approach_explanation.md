# Adobe Hackathon Round 1A – Approach Explanation

## Problem Overview

In Round 1A of the Adobe Hackathon, the challenge is to convert raw PDF documents into structured outlines. This involves extracting the **document title** and a **hierarchical list of headings** (H1, H2, H3), along with their respective page numbers. The goal is to make PDFs machine-readable and enable intelligent navigation, summarization, and search in future applications.

---

## Solution Architecture

Our pipeline consists of the following major steps:

### 1. **Title Extraction**
- First, we attempt to extract the document title from PDF metadata using `PyPDF2`.
- If metadata is missing or unhelpful, we fall back to:
  - Extracting prominent lines from the first page using `pdfplumber` and `PyMuPDF`
  - Analyzing font sizes and content heuristics (e.g., rejecting dates, links, or common words)
- A candidate is accepted as title only if it passes length, structure, and formatting criteria.

### 2. **Outline Extraction**
We employ a two-tier approach:

#### a. **Native Table of Contents (ToC)**
- If the document has a built-in Table of Contents (ToC), we use `PyMuPDF` to extract it.
- ToC entries are normalized into heading levels (H1–H3) and include the associated page number.

#### b. **Heuristic Heading Detection (Fallback)**
- If no ToC is available, we parse each page for text blocks using `PyMuPDF`.
- All font sizes from visible spans are collected and normalized.
- For each text span, we apply the following criteria to detect headings:
  - Font size is relatively large compared to the overall size range
  - Text is bold (using font flags), capitalized, short, and does not resemble a date or number
- Headings are then classified into H1, H2, or H3 based on their normalized font size.

---

## Filtering and Edge Cases

- We apply regex filters to avoid interpreting **dates** (e.g., "March 2005"), **page numbers**, or **URLs** as titles/headings.
- Duplicate headings and extremely short/long lines are discarded.
- Headings are deduplicated using a `seen` set.

---

## Output Format

The final JSON output conforms to the required format:

```json
{
  "title": "Sample PDF Title",
  "outline": [
    { "level": "H1", "text": "Introduction", "page": 0 },
    { "level": "H2", "text": "Background", "page": 1 },
    { "level": "H3", "text": "Details", "page": 2 }
  ]
}
