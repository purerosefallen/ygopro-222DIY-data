--少女的黑暗夜之梦
function c65020139.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5da7))
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c65020139.condition)
	e2:SetCost(c65020139.cost)
	e2:SetTarget(c65020139.target)
	e2:SetOperation(c65020139.operation)
	c:RegisterEffect(e2)
end
function c65020139.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp and Duel.GetAttackTarget()==nil 
end
function c65020139.costfil(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x5da7) and c:IsType(TYPE_MONSTER)
end
function c65020139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020139.costfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65020139.costfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c65020139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65020139.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5da7)
end
function c65020139.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local atk=e:GetLabelObject():GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(atk)
	e1:SetValue(c65020139.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.BreakEffect()
	local mmm=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if mmm:GetCount()>0 then
		Duel.ConfirmCards(1-tp,mmm)
		if mmm:FilterCount(c65020139.dfilter,nil)==0 then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c65020139.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		local atk=e:GetLabel()
		return dam-atk
	else return dam end
end
