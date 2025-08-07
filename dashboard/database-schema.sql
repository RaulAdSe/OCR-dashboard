-- OCR Dashboard Database Schema
-- Run this in your Supabase SQL Editor

-- Companies table - stores extracted company information
CREATE TABLE IF NOT EXISTS companies (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT,
    address TEXT,
    city TEXT,
    country TEXT,
    phone TEXT,
    email TEXT,
    website TEXT,
    role TEXT, -- expedidor, destinatario, transportista
    source_document_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents table - tracks OCR processing
CREATE TABLE IF NOT EXISTS documents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    filename TEXT NOT NULL,
    file_path TEXT,
    google_drive_id TEXT,
    processing_status TEXT DEFAULT 'pending' CHECK (processing_status IN ('pending', 'processing', 'completed', 'failed')),
    ocr_confidence DECIMAL(3,2), -- 0.00 to 1.00
    extracted_text TEXT,
    gemini_file_id TEXT, -- Gemini API file reference
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE,
    error_message TEXT
);

-- API Usage table - tracks costs for Gemini, SerpAPI, Firecrawl
CREATE TABLE IF NOT EXISTS api_usage (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    api_name TEXT NOT NULL CHECK (api_name IN ('gemini', 'serpapi', 'firecrawl')),
    usage_type TEXT, -- 'ocr', 'search', 'email_finder', etc.
    cost DECIMAL(10,4) DEFAULT 0.0000, -- Cost in USD
    usage_count INTEGER DEFAULT 1,
    document_id UUID,
    company_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metadata JSONB -- Additional details about the API call
);

-- Document-Company relationship (many-to-many)
CREATE TABLE IF NOT EXISTS document_companies (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    role TEXT, -- expedidor, destinatario, transportista
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(document_id, company_id, role)
);

-- Enable Row Level Security (RLS)
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_companies ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (adjust as needed for your security requirements)
CREATE POLICY "Allow public read access on companies" ON companies FOR SELECT USING (true);
CREATE POLICY "Allow public read access on documents" ON documents FOR SELECT USING (true);
CREATE POLICY "Allow public read access on api_usage" ON api_usage FOR SELECT USING (true);
CREATE POLICY "Allow public read access on document_companies" ON document_companies FOR SELECT USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_companies_name ON companies(name);
CREATE INDEX IF NOT EXISTS idx_companies_created_at ON companies(created_at);
CREATE INDEX IF NOT EXISTS idx_documents_status ON documents(processing_status);
CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at);
CREATE INDEX IF NOT EXISTS idx_api_usage_api_name ON api_usage(api_name);
CREATE INDEX IF NOT EXISTS idx_api_usage_created_at ON api_usage(created_at);

-- Insert some sample data for testing
INSERT INTO documents (filename, processing_status, ocr_confidence, extracted_text) VALUES 
('sample_cmr_001.pdf', 'completed', 0.95, 'Sample extracted text from CMR document'),
('sample_cmr_002.pdf', 'processing', null, null),
('sample_cmr_003.pdf', 'failed', null, null);

INSERT INTO companies (name, address, city, country, phone, email, role) VALUES 
('Transport Solutions S.L.', 'Calle Mayor 123', 'Madrid', 'Spain', '+34 91 123 4567', 'info@transportsolutions.es', 'transportista'),
('Logistics Europe GmbH', 'Hauptstraße 45', 'Berlin', 'Germany', '+49 30 123 4567', 'contact@logistics-eu.de', 'expedidor'),
('Cargo Italia SRL', 'Via Roma 78', 'Milan', 'Italy', '+39 02 123 4567', 'info@cargoitalia.it', 'destinatario');

INSERT INTO api_usage (api_name, usage_type, cost, usage_count) VALUES 
('gemini', 'ocr_processing', 0.0250, 1),
('serpapi', 'company_search', 0.0100, 1),
('firecrawl', 'web_scraping', 0.0000, 1);

-- Create a view for dashboard statistics
CREATE OR REPLACE VIEW dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM companies) as total_companies,
    (SELECT COUNT(*) FROM documents) as total_documents,
    (SELECT COUNT(*) FROM documents WHERE processing_status = 'completed') as completed_documents,
    (SELECT COALESCE(SUM(cost), 0) FROM api_usage) as total_api_cost,
    (SELECT COALESCE(AVG(ocr_confidence), 0) FROM documents WHERE ocr_confidence IS NOT NULL) as avg_confidence,
    (SELECT COUNT(*) FROM documents WHERE processing_status = 'failed') as failed_documents;

COMMENT ON TABLE companies IS 'Stores company information extracted from OCR documents';
COMMENT ON TABLE documents IS 'Tracks document processing status and OCR results';
COMMENT ON TABLE api_usage IS 'Monitors API usage and costs for Gemini, SerpAPI, and Firecrawl';
COMMENT ON TABLE document_companies IS 'Links documents to the companies mentioned in them';