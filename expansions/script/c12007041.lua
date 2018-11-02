local m=12007041
local cm=_G["c"..m]
--兔姬，轻盈的短剑
function cm.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--sp op
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0x14000)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.rfilter(c,tp)
	return c:IsSetCard(0xfb2) and (c:IsControler(tp) or c:IsFaceup()) and c:IsReleasable()
end
function cm.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function cm.spcon(e,c,tp)
	if c==nil then return true end
	local rg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_ONFIELD,0,tp)
	local ft=Duel.GetMZoneCount(tp,nil,tp)
	local ct=-ft+1
	return ft>-3 and rg:GetCount()>3 and (ft>0 or rg:IsExists(cm.mzfilter,ct,nil,tp))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD 
	if ft<0 then loc=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,loc,0,c,e)
	if chkc then return false end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=3 and (ft>0 or g:IsExists(cm.rfilter,-ft+1,nil,LOCATION_MZONE)) 
	end
		local g1,g2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		if ft<1 then
		   g1=g:FilterSelect(tp,cm.rfilter,1,1,nil,LOCATION_MZONE)
		else
		   g1=g:Select(tp,1,1,nil)
		end
		g:RemoveCard(g1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=g:Select(tp,2,10,nil)
		g1:Merge(g2)
		Duel.Release(g1,REASON_COST)
		local tt=g1:GetCount()
		for i=1,tt do
			 c:RegisterFlagEffect(12007041,RESET_EVENT+0x1fe0000-RESET_TOFIELD,0,1)
		end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12007041)>0
end
function cm.filter1(c)
	return c:IsSetCard(0xfb2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(m)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tt=c:GetFlagEffect(m)
	for i=1,tt do
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
	 end
   end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.tfilter(c,e)
	return c:GetEquipTarget()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
	local code=tc:GetOriginalCode()
		   if c:IsRelateToEffect(e) and c:IsFaceup() then
			  if c:GetFlagEffect(code)>0 then return end
				c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
				c:RegisterFlagEffect(code,RESET_EVENT+0x1fe000,0,1)
			end
	tc=g:GetNext() 
	end
 end 
end
