<?php

/**
 * @file
 * Alter view data for bean block entity.
 */

/**
 * Implements hook_views_data_alter().
 */
function bean_views_data_alter(&$data) {
  $data['bean']['table']['group'] = 'Block';

  $data['bean']['table']['entity type'] = 'bean';

  $data['bean']['type'] = array(
    'title' => t('Type'),
    'help' => t('The block type'),
    'field' => array(
      'handler' => 'views_handler_field_bean_type',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_bean_type',
    ),
  );

  $data['bean']['edit_link'] = array(
    'title' => t('Edit link'),
    'help' => t('Edit link for bean block'),
    'field' => array(
      'handler' => 'views_handler_field_bean_edit_link',
    ),
  );

  $data['bean']['delete_link'] = array(
    'title' => t('Delete link'),
    'help' => t('Delete link for bean block'),
    'field' => array(
      'handler' => 'views_handler_field_bean_delete_link',
    ),
  );

  $data['bean']['operations'] = array(
    'title' => t('Contextual / Operation links'),
    'help' => t('Display all the available contextual / operation links for the block.'),
    'field' => array(
      'handler' => 'views_handler_field_bean_operations',
    ),
  );

  $data['bean']['bulk_form'] = array(
    'title' => t('Bulk operations'),
    'help' => t('Provides a checkbox on each row and a form for executing bulk actions on Beans.'),
    'real field' => 'bid',
    'field' => array(
      'handler' => 'views_handler_field_bulk_form',
      'click sortable' => FALSE,
    ),
  );
}

/**
 * Implements hook_form_FORM_ID_alter().
 */
function bean_form_views_exposed_form_alter(&$form, &$form_state, $form_id) {
  if ($form['#id'] == 'views-exposed-form-blocks-page') {
    $form['author']['#size'] = 30;
  }
}
