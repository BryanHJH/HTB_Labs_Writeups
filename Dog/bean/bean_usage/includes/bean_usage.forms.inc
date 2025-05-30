<?php
/**
 * @todo Please document this function.
 * @see http://drupal.org/node/1354
 */
function bean_usage_settings() {
  $form = array();
  $form['#config'] = 'bean_usage.settings';

  $form['bean_usage_results'] = array(
    '#type' => 'fieldset',
    '#title' => t('Results per page'),
    '#weight' => 0,
    '#collapsible' => FALSE,
  );

  $form['bean_usage_results']['results_per_page'] = array(
    '#title' => t('Results per page'),
    '#description' => t('How many results display per page on the bean usage page'),
    '#type' => 'select',
    '#options' => array(
      '5' => 5,
      '10' => 10,
      '15' => 15,
      '20' => 20,
      '25' => 25,
      '30' => 30,
      '35' => 35,
      '40' => 40,
      '45' => 45,
      '50' => 50,
    ),
    '#default_value' => config_get('bean_usage.settings', 'results_per_page'),
  );

  return system_settings_form($form);
}

/**
 * Filter form for bean usage view
 *
 * @return array
 */
function bean_usage_filters() {
  $filters = backdrop_get_query_parameters();
  $filters['type'] = empty($filters['type']) ? '' : explode(',', $filters['type']);

  $form = array();

  $form['bean_usage_filter'] = array(
    '#type' => 'fieldset',
    '#title' => t('Filter by bean type'),
    '#weight' => 0,
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  );

  $bean_types = bean_get_types();
  $options = array();
  foreach ($bean_types as $bean) {
    $options[$bean->type] = $bean->type;
  }

  asort($options);
  $multiple = TRUE;

  $form['bean_usage_filter']['bean_usage_filter_type'] = array(
    '#type' => 'select',
    '#prefix' => '<div style="margin-right:10px; position:relative; float:left;">',
    '#suffix' => '</div>',
    '#multiple' => $multiple,
    '#size' => $multiple?min(4, count($options)) : 0,
    '#title' => t('Filter type'),
    '#description' => t('Choose the bean types to filter the list of results.'),
    '#options' => $options,
    '#default_value' => $filters['type'],
  );
  $form['bean_usage_filter']['bean_usage_filter_title'] = array(
    '#type' => 'textfield',
    '#title' => t('Title'),
    '#prefix' => '<div style="margin-right:10px; position:relative; float:left;">',
    '#suffix' => '</div>',
    '#default_value' => !empty($filters['title']) ? $filters['title'] : '',
  );
  $form['bean_usage_filter']['bean_usage_filter_label'] = array(
    '#type' => 'textfield',
    '#title' => t('Label'),
    '#prefix' => '<div style="margin-right:10px; position:relative; float:left;">',
    '#suffix' => '</div>',
    '#default_value' => !empty($filters['label']) ? $filters['label'] : '',
  );

  $form['bean_usage_filter']['actions'] = array(
    '#type' => 'actions',
    '#prefix' => '<div style="position:relative; float:left;">',
    '#suffix' => '</div>',
  );

  $form['bean_usage_filter']['actions']['apply'] = array(
    '#type' => 'submit',
    '#value' => t('Apply'),
  );

  $form['bean_usage_filter']['actions']['reset'] = array(
    '#type' => 'submit',
    '#value' => t('Reset'),
  );

  return $form;
}

/**
 * Submit function for bean_usage_filters()
 *
 * Applies the filter via a redirect back to the bean usage view page with the added filter query param.
 *
 * @param $form
 * @param $form_state
 */
function bean_usage_filters_submit(&$form, &$form_state) {
  // Get the query string parameters minus the backdrop url and filter param
  $params = backdrop_get_query_parameters($_GET, array('q', 'filter'));

  // add the filters to the query string
  $filters = array(
    'type' => join(',', $form_state['values']['bean_usage_filter_type']),
    'title' => $form_state['values']['bean_usage_filter_title'],
    'label' => $form_state['values']['bean_usage_filter_label'],
  );

  switch (strtolower($form_state['values']['op'])) {
    case 'apply':
      foreach ($filters as $filter_name => $filter_value) {
        if (!empty($filter_value)) {
          $params[$filter_name] = $filter_value;
        }
      }
      break;
    case 'reset':
      $params = array();
      break;
  }

  // Redirect back to bean usage view with added filter query string param
  backdrop_goto($_GET['q'], array('query' => $params));
}
