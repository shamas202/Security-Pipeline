"use strict";

const request = require("supertest");
const { app } = require("../server");

describe("Security Headers", () => {
  test("should set X-Content-Type-Options: nosniff", async () => {
    const res = await request(app).get("/");
    expect(res.headers["x-content-type-options"]).toBe("nosniff");
  });

  test("should set Strict-Transport-Security", async () => {
    const res = await request(app).get("/");
    expect(res.headers["strict-transport-security"]).toMatch(/max-age=/);
  });

  test("should set Content-Security-Policy", async () => {
    const res = await request(app).get("/");
    expect(res.headers["content-security-policy"]).toBeDefined();
  });

  test("should not expose X-Powered-By header", async () => {
    const res = await request(app).get("/");
    expect(res.headers["x-powered-by"]).toBeUndefined();
  });

  test("should set X-Frame-Options: DENY", async () => {
    const res = await request(app).get("/");
    expect(res.headers["x-frame-options"]).toBe("DENY");
  });

  test("should return X-Request-ID header", async () => {
    const res = await request(app).get("/");
    expect(res.headers["x-request-id"]).toBeDefined();
    expect(res.headers["x-request-id"]).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    );
  });
});

describe("GET /healthz", () => {
  test("should return 200 and status ok", async () => {
    const res = await request(app).get("/healthz");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("ok");
  });
});

describe("GET /readyz", () => {
  test("should return 200 and status ready", async () => {
    const res = await request(app).get("/readyz");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("ready");
  });
});

describe("GET /", () => {
  test("should return 200 with API info", async () => {
    const res = await request(app).get("/");
    expect(res.status).toBe(200);
    expect(res.body.message).toBe("DevSecOps API");
  });
});

describe("GET /api/v1/status", () => {
  test("should return operational status", async () => {
    const res = await request(app).get("/api/v1/status");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("operational");
    expect(res.body.uptime).toBeGreaterThanOrEqual(0);
    expect(res.body.timestamp).toBeDefined();
  });
});

describe("POST /api/v1/echo", () => {
  test("should echo a valid message", async () => {
    const res = await request(app)
      .post("/api/v1/echo")
      .send({ message: "Hello, World!" });
    expect(res.status).toBe(200);
    expect(res.body.echo).toBe("Hello, World!");
  });

  test("should reject missing message", async () => {
    const res = await request(app).post("/api/v1/echo").send({});
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/Invalid input/);
  });

  test("should reject non-string message", async () => {
    const res = await request(app)
      .post("/api/v1/echo")
      .send({ message: 12345 });
    expect(res.status).toBe(400);
  });

  test("should reject message over 500 chars", async () => {
    const res = await request(app)
      .post("/api/v1/echo")
      .send({ message: "a".repeat(501) });
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/too long/i);
  });

  test("should sanitize HTML tags", async () => {
    const res = await request(app)
      .post("/api/v1/echo")
      .send({ message: "<script>alert('xss')</script>safe" });
    expect(res.status).toBe(200);
    expect(res.body.echo).toBe("safe");
    expect(res.body.echo).not.toMatch(/<script>/);
  });

  test("should reject body larger than 10kb", async () => {
    const res = await request(app)
      .post("/api/v1/echo")
      .send({ message: "a".repeat(11000) });
    expect(res.status).toBeGreaterThanOrEqual(400);
  });
});

describe("404 handler", () => {
  test("should return 404 for unknown routes", async () => {
    const res = await request(app).get("/unknown-route");
    expect(res.status).toBe(404);
    expect(res.body.error).toBe("Not Found");
  });
});
// Test case for Update app/__tests__/server.test.js: Add edge case test
// Test case for Update app/__tests__/server.test.js: Improve test descriptions
// Iteration 1: trivial update
