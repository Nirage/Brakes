import React from "react";

type Props = {
  msg: string;
};

const respondFunction = () => {
  alert('We have responded');
};

export default ({ msg }: Props) => (
  <button onClick={() => respondFunction()}>{msg}</button>
);