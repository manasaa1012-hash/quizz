import assert from "node:assert/strict";
import test from "node:test";
import { requireAdmin, requireAuth } from "../middleware/auth.js";

test("authentication middleware rejects a missing bearer token", async () => {
  let status = 0; let payload: any;
  const response: any = { status(value: number) { status = value; return this; }, json(value: any) { payload = value; return this; } };
  await requireAuth({ headers: {} } as any, response, () => assert.fail("next should not be called"));
  assert.equal(status, 401);
  assert.equal(payload.message, "Authentication required");
});

test("admin middleware rejects students and accepts admins", () => {
  let studentError: any;
  requireAdmin({ profile: { role: "student" } } as any, {} as any, error => { studentError = error; });
  assert.equal(studentError.status, 403);
  let adminAdvanced = false;
  requireAdmin({ profile: { role: "admin" } } as any, {} as any, error => { assert.equal(error, undefined); adminAdvanced = true; });
  assert.equal(adminAdvanced, true);
});
