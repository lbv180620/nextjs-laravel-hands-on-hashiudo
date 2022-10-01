import { render, screen } from "@testing-library/react";

import "@testing-library/jest-dom/extend-expect";
import Home from "@/pages/index";

describe("Home page rendering test", () => {
  it("should render the texts on Home page?", () => {
    render(<Home />);

    expect(screen.getByText("メールアドレス")).toBeInTheDocument();
    expect(screen.getByText("パスワード")).toBeInTheDocument();
    expect(screen.getByRole("button")).toBeInTheDocument();
  });
});
