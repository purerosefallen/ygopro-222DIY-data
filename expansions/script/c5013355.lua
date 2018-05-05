--蓝染惣右介
function c5013355.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),7,7)   
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c5013355.regcon)
	e1:SetOperation(c5013355.regop)
	c:RegisterEffect(e1)
end
function c5013355.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_LINK)==7
end
function c5013355.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c5013355.con)
	e1:SetOperation(c5013355.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c5013355.con2)
	e2:SetOperation(c5013355.op2)
	c:RegisterEffect(e2)
end
function c5013355.con2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:IsControler(1-tp) and not d) or (d and d:IsControler(tp))
end
function c5013355.op2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetHandler()) or not Duel.NegateAttack() then return end
	local atk=Duel.GetAttacker():GetAttack()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local a1,a2=g:GetCount()>0,atk>0
	if not a1 and not a2 then return end
	if a1 and (not a2 or not Duel.SelectYesNo(tp,aux.Stringid(5013355,1))) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local dg=g:Select(tp,1,1,nil)
	   Duel.HintSelection(dg)
	   Duel.Destroy(dg,REASON_EFFECT)   
	else
	   local lp=Duel.GetLP(1-tp)
	   if atk>=lp then Duel.SetLP(1-tp,0)
	   else Duel.SetLP(1-tp,lp-atk)
	   end
	end
end
function c5013355.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and (Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,nil))
end
function c5013355.cfilter(c)
	return c:IsOnField() or c:IsAbleToDeck()
end
function c5013355.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	Duel.Hint(HINT_CARD,0,5013355)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c5013355.repop)
end
function c5013355.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(1-tp,c5013355.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,1,nil):GetFirst()
	if not tc then return end
	if not tc:IsOnField() or not Duel.SelectYesNo(1-tp,aux.Stringid(5013355,0)) then
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	else
	   Duel.Destroy(tc,REASON_EFFECT)
	end
end
