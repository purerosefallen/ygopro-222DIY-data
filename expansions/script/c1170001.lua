--捣蛋小鬼-璃
function c1170001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c1170001.cost1)
	e1:SetTarget(c1170001.tg1)
	e1:SetOperation(c1170001.op1)
	c:RegisterEffect(e1)
--
end
--
function c1170001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_PUBLIC)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1,true)
end
--
function c1170001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) 
		and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1170001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() then return end
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetDescription(aux.Stringid(1170001,0))
	e1_2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EXTRA_ATTACK)
	e1_2:SetValue(1)
	e1_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_2)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetDescription(aux.Stringid(1170001,1))
	e1_3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1_3:SetRange(LOCATION_MZONE)
	e1_3:SetCondition(c1170001.con1_3)
--  e1_3:SetTarget(c1170001.tg1_3)
	e1_3:SetOperation(c1170001.op1_3)
	e1_3:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_3)
end
--
function c1170001.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
end
--
function c1170001.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	local ag=c:GetAttackableTarget()
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if cg:GetCount()<1 then return end
	if c:IsImmuneToEffect(e) then return end
	local cc=cg:GetFirst()
	while cc do
		if ag:IsContains(cc) then sg:AddCard(cc) end
		cc=cg:GetNext()
	end
	if sg:GetCount()<1 then return end
	local tg=sg:RandomSelect(tp,1)
	local tc=tg:GetFirst()
	Duel.ChangeAttackTarget(tc)
end
--
