import express from "express";
import { Pool } from "pg";

const pool = new Pool();
const app = express();
const port = Number(process.env.PORT ?? 3000);

async function init(): Promise<void> {
  await pool.query(
    "CREATE TABLE IF NOT EXISTS visits (id SERIAL PRIMARY KEY, at TIMESTAMPTZ DEFAULT now())"
  );
}

app.get("/", async (_req, res) => {
  await pool.query("INSERT INTO visits DEFAULT VALUES");
  const { rows } = await pool.query("SELECT count(*)::int AS total FROM visits");
  res.json({ 
    message: "Bonjour depuis le TP7 - Version modifiée pour le cache", 
    visits: rows[0].total, 
    host: process.env.HOSTNAME 
  });
});

app.get("/health", async (_req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok" });
  } catch {
    res.status(503).json({ status: "db-unavailable" });
  }
}); // <-- C'était cette accolade qui manquait !

init().then(() => {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
});
