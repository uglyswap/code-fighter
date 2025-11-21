import { getGithubUser } from "../handlers/github_handlers";

export async function getGitAuthor() {
  const user = await getGithubUser();
  const author = user
    ? {
        name: `[code-fighter]`,
        email: user.email,
      }
    : {
        name: "[code-fighter]",
        email: "git@codefighter.dev",
      };
  return author;
}
