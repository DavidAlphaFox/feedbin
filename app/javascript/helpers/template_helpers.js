export function templateText(element, selector, value) {
  let result = element.querySelector(`[data-template=${selector}]`)
  if (result) {
    result.textContent = value
  } else {
    console.log(`templateText missing selector: ${selector}`);
  }
}

export function templateHTML(element, selector, value) {
  let result = element.querySelector(`[data-template=${selector}]`)
  if (result) {
    result.innerHTML = ""
    result.append(value)
  } else {
    console.log(`templateHTML missing selector: ${selector}`);
  }
}
