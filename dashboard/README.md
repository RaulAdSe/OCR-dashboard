# OCR Dashboard

A Next.js dashboard for visualizing OCR system results, company information, and API cost tracking.

## Features

- **Dashboard Overview**: Real-time statistics and database connection status
- **Companies**: View and manage extracted company information
- **Documents**: Monitor document processing status and OCR results
- **Cost Tracking**: Track API usage costs for Gemini, SerpAPI, and Hunter.io
- **Analytics**: Analyze processing performance and trends
- **Database Explorer**: Browse database tables and their contents

## Prerequisites

- Node.js 18.x or later
- Supabase account and database
- Environment variables configured

## Installation

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
Create a `.env.local` file with your Supabase credentials:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
DATABASE_URL=your_postgresql_connection_string
```

## Development

Run the development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the dashboard.

## Production Build

Build the application:
```bash
npm run build
```

Start the production server:
```bash
npm start
```

## Deployment

### Vercel (Recommended)

1. Connect your repository to Vercel
2. Add environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Alternative Deployment

The application can be deployed to any platform that supports Next.js applications:
- Netlify
- Railway
- Digital Ocean App Platform
- AWS Amplify

## Database Schema

The dashboard expects the following tables in your Supabase database:

- `companies` - Company information extracted from documents
- `documents` - Document processing records and OCR results
- `api_usage` - API usage tracking for cost monitoring

## Technology Stack

- **Framework**: Next.js 15 with App Router
- **Styling**: Tailwind CSS
- **Database**: Supabase (PostgreSQL)
- **Charts**: Recharts
- **Icons**: Lucide React
- **TypeScript**: Full type safety

## License

Private project for OCR system dashboard.
