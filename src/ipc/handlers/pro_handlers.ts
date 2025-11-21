import fetch from "node-fetch"; // Electron main process might need node-fetch
import log from "electron-log";
import { createLoggedHandler } from "./safe_handle";
import { readSettings } from "../../main/settings"; // Assuming settings are read this way
import { UserBudgetInfo, UserBudgetInfoSchema } from "../ipc_types";
import { IS_TEST_BUILD } from "../utils/test_utils";

const logger = log.scope("pro_handlers");
const handle = createLoggedHandler(logger);

const CONVERSION_RATIO = (10 * 3) / 2;

export function registerProHandlers() {
  // Code Fighter: Return unlimited credits without API call
  handle("get-user-budget", async (): Promise<UserBudgetInfo | null> => {
    logger.info("Code Fighter: Returning unlimited credits.");

    // Return unlimited credits - no API call needed
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);

    return UserBudgetInfoSchema.parse({
      usedCredits: 0,
      totalCredits: 999999,
      budgetResetDate: nextMonth,
    });
  });
}
