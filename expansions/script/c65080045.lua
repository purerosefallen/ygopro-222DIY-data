--秘密之妖精庭园
function c65080045.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65080045.condition)
	e1:SetOperation(c65080045.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c65080045.indcon)
	e2:SetTarget(c65080045.indtg)
	e2:SetOperation(c65080045.indop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(65080045,ACTIVITY_SPSUMMON,c65080045.countfilter)
end
function c65080045.countfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c65080045.filterfil(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevel(3))
end
function c65080045.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local m=0
	local n=0
	if b and a:IsControler(tp) and ((a:IsAttribute(ATTRIBUTE_WIND) and a:IsLevel(3)) or (a:IsType(TYPE_XYZ) and a:GetOverlayGroup():FilterCount(c65080045.filterfil,nil)==0)) then m=1 end
	if b and b:IsControler(tp) and ((b:IsAttribute(ATTRIBUTE_WIND) and b:IsLevel(3)) or (b:IsType(TYPE_XYZ) and b:GetOverlayGroup():FilterCount(c65080045.filterfil,nil)==0)) then n=1 end
	return m==1 or n==1 
end
function c65080045.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.GetAttackTarget() and a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	local m=Duel.SelectOption(tp,aux.Stringid(65080045,0),aux.Stringid(65080045,1))
	if m==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65080045,0))
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetLabelObject(a)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetCondition(c65080045.con)
		e2:SetTarget(c65080045.tg)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
	elseif m==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65080045,1))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetLabelObject(a)
		e1:SetCondition(c65080045.con)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65080045.con(e)
	local a=e:GetLabelObject()
	return Duel.GetAttacker()==a or Duel.GetAttackTarget()==a
end
function c65080045.tg(e,c)
	local a=e:GetLabelObject()
	return c==a
end
function c65080045.cfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevel(3) and c:GetSummonPlayer()==tp 
end
function c65080045.indcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65080045.cfilter,1,nil,nil,tp)
end
function c65080045.tgfil(c,e)
	return c:IsSummonable(true,e) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevel(3)
end
function c65080045.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65080045,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c65080045.tgfil,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65080045.indop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c65080045.tgfil,tp,LOCATION_HAND,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,e)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end