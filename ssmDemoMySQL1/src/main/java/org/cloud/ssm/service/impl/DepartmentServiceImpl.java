package org.cloud.ssm.service.impl;

import org.cloud.ssm.entity.Department;
import org.cloud.ssm.mapper.DepartmentMapper;
import org.cloud.ssm.service.DepartmentService;
import org.cloud.ssm.utils.BaseServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class DepartmentServiceImpl extends BaseServiceImpl<DepartmentMapper, Department> implements DepartmentService {

}
