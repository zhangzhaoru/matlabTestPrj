# Inertial navigation basic

**����ֿ����Ҫ�����ǻ����ߵ�������򡣰����Ϲ�����ʦ �����ߵ��㷨����ϵ���ԭ�� �ϵ�matlabʾ�������Լ����Լ�д����̬����Ͷ�׼�ȳ���**

---

#1.  ��ѭ���Ƚ��ͣ���ִ�С���ԭ��ע������д�ڶ�Ӧ�����ǰ�棨���Ϸ�����

#2.  ע�⣺��matlab�����б�ʾͬʱ�����ϱ���±�ı���ʱ

?	���ϵĳ��������ա��ϱ���ǰ���±��ں󡱵�ԭ��

?	����ʵ����ϰ���ϰ��� ���±���ǰ���ϱ��ں󡱵�ԭ��

��ˣ����ж��� "��bϵ��nϵ�Ĺ��ɾ���" Cbn ��д��ΪCnb������ϰ��ԭ����ѡ����ߣ���˳�������Щ�����������������в��죬���ֲ��������������汾֮�С�

#3.  ���ǰ������¹�������ʾλ�á��ٶȱ�����

?	pos : [γ��, ����, �߶�] ��λΪrad, rad, m

?	vn : [vE, vN, vU] ��λΪm/s

���⣬��������˵������ʾ�Ƕȱ����ĵ�λ����rad�������������ĵ�λ������Ӧ�Ĺ��ʵ�λ��

#4. ��**_ref**��β������ע���г���Ϊ���ο�ֵ��������׼ֵ�������߾���ʾ����ʵ������û����֮�⡣���У����˸�Ը��ʵ�������еĸ߾��Ȳο���Ϊ���ο�ֵ�����ѷ���������ɵľ���׼ȷ�Ľ����Ϊ����׼ֵ������ʵֵ�������������д��������ʱҲû������ôϸ��

#5. 

#6.  ���Ǳ�����**k**���ò��������ã���ű����Сд**k**��ʾ�� **k_init** ��ָ��ֵ���ݻ�����е�һ��ʱ�����ݵı��

#7. ������ **imuError**��ָ**�����������**���������ö���imu��Ӧ��Ϊ**imuError_1**,**imuError_phins**...

#8. �ӳ����׼ȷ�ԺͿɶ��ԽǶ��������ڼ���/����/��ֵʱ��������Ӧ�ĵ�λ����ֵ�õġ������ǵ�����������ĵ�λ���ǹ��ʵ�λ�����ڼ���Կ��ǣ��ڲ����������ǰ���£�ʡ�Թ��ʵ�λ

---

**һЩ��д�ĺ���:**
**ref**: reference    **msr**: measurement    **stg**: storage    **err**: error    **prev**: previous    **opt**: optimal  **crt**: current    **init**: initial    **num**: number     **calc**: calculate    **Lp**: loop of ..    **idx**: index    **simData**: simulation data     **fig:** figure    **info:** information    **ts:** time of step

**����ר����д:**

**avp**: attitude velocity attitude    **pos**: positon    **att**: attitude    **vn**: ground velocity     **acc**: accelerometer    **gyr**: gyroscope    **ang**: angle    **imu.fb:** specific force in b frame    **imu.wb:** angular velocity in b frame    **imu.tb:** angular increment     **imu.vb:** velocity increment    **navinfo:** navigation information

***

 ***����ʱ�䣺2020��12��5��***

