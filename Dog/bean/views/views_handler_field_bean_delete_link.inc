<?php

/**
 * @file
 * Definition of views_handler_field_node_link.
 */

/**
 * Field handler to present a link to the node.
 *
 * @ingroup views_field_handlers
 */
class views_handler_field_bean_delete_link extends views_handler_field_entity {

  function option_definition() {
    $options = parent::option_definition();
    $options['text'] = array(
      'default' => '',
      'translatable' => TRUE,
    );
    return $options;
  }

  function options_form(&$form, &$form_state) {
    $form['text'] = array(
      '#type' => 'textfield',
      '#title' => t('Text to display'),
      '#default_value' => $this->options['text'],
    );
    parent::options_form($form, $form_state);

    // The path is set by render_link function so don't allow to set it.
    $form['alter']['path'] = array('#access' => FALSE);
    $form['alter']['external'] = array('#access' => FALSE);
  }

  function render($values) {
    if ($entity = $this->get_value($values)) {
      return $this->render_link($entity);
    }
  }

  function render_link($bean) {
    if (entity_plus_access('delete', 'bean', $bean)) {
      $this->options['alter']['make_link'] = TRUE;
      $this->options['alter']['path'] = "block/$bean->delta/delete";
      $this->options['alter']['query'] = backdrop_get_destination();
      $text = !empty($this->options['text']) ? $this->options['text'] : t('delete');
      return $text;
    }
  }
}
