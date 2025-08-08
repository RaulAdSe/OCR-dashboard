# OCR Dashboard Deployment Guide

## Local Development Setup

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd "OCR Kolmai/dashboard"
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   ```
   
   Edit `.env.local` with your actual values:
   - `NEXT_PUBLIC_SUPABASE_URL`: Your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Your Supabase anon key
   - `SUPABASE_SERVICE_ROLE_KEY`: Your Supabase service role key
   - `DATABASE_URL`: Your PostgreSQL connection string
   - `NEXT_PUBLIC_DASHBOARD_PASSWORD`: Your dashboard access password

4. **Run the development server**
   ```bash
   npm run dev
   ```

## Vercel Deployment

### Prerequisites
- GitHub repository with your code
- Supabase project set up
- Vercel account (free tier works perfectly)

### Steps

1. **Connect to Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Select the `dashboard` folder as root directory

2. **Environment Variables**
   Set these in Vercel dashboard under Settings → Environment Variables:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...your-key
   SUPABASE_SERVICE_ROLE_KEY=eyJ...your-service-key
   DATABASE_URL=postgresql://postgres:password@your-host:5432/postgres
   NEXT_PUBLIC_DASHBOARD_PASSWORD=your_secure_password
   ```

3. **Deploy**
   - Vercel will automatically build and deploy
   - Your dashboard will be live at `https://your-project.vercel.app`

### Free Tier Limits
- **Vercel**: 100GB bandwidth, 1000 function invocations/day
- **Supabase**: 50MB database, 2GB bandwidth, 50k monthly active users
- **Perfect for**: Dashboard usage, small-medium teams

## Database Setup

Ensure your Supabase database has the required tables:
- `cmr_documents` - Document processing data
- `companies` - Company information
- `document_companies` - Relationships

Run the SQL schema in `database-schema.sql` if needed.

## Security Notes

- ✅ Environment variables are properly ignored by git
- ✅ Secrets are only stored in deployment environment
- ✅ Password protection prevents unauthorized access
- ✅ RLS policies should be configured in Supabase

## Features

- 🔒 Password-protected dashboard with progressive timeouts
- 📊 Cost tracking for Gemini OCR, SerpAPI, and Firecrawl
- 🏢 Company management with tax ID support
- ⚠️ API error notifications from document processing
- 📱 Responsive design for mobile and desktop