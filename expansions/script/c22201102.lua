--吟游终曲
function c22201102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,22201102+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22201102.condition)
	e1:SetCost(c22201102.cost)
	e1:SetOperation(c22201102.activate)
	c:RegisterEffect(e1)
end
function c22201102.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c22201102.costfilter(c,bc)
	return c:IsAbleToRemoveAsCost() and (bit.band(c:GetAttribute(),bc:GetAttribute())~=0 or bit.band(c:GetRace(),bc:GetRace())~=0)
end
function c22201102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if ac:GetControler()==tc:GetControler() then return false end
	local bg=Group.FromCards(ac,tc)
	local bc=bg:Filter(Card.IsControler,nil,tp):GetFirst()
	if chk==0 then return bc and Duel.IsExistingMatchingCard(c22201102.costfilter,tp,LOCATION_GRAVE,0,1,nil,bc) end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(c22201102.costfilter,nil,bc)
	local tg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tg:AddCard(tc)
	g:Remove(Card.IsCode,nil,tc:GetCode())
	while g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22201102,0)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if ct>0 then
		e:SetLabel(ct)
	else
		e:SetLabel(0)
	end
end
function c22201102.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	local bg=Group.FromCards(ac,tc)
	local bc=bg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	local ct=e:GetLabel()
	if bc and bc:IsRelateToBattle() and ct>0 then
		local atk=bc:GetAttack()
		local def=bc:GetDefense()
		while ct>0 do
			atk=atk/2
			def=def/2
			ct=ct-1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetCondition(c22201102.rdcon)
		e2:SetOperation(c22201102.rdop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22201102.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22201102.rdfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22201102.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c22201102.rdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22201102,1)) then
		Duel.Hint(HINT_CARD,0,22201102)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=Duel.SelectMatchingCard(tp,c22201102.rdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if rg:GetCount()>0 then
			Duel.SendtoHand(rg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,rg)
		end
	end
end