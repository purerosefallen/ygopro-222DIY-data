--犄角
function c65071044.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,65071044+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65071044.condition)
	e1:SetTarget(c65071044.target)
	e1:SetOperation(c65071044.operation)
	c:RegisterEffect(e1)
end
function c65071044.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and tp~=rp and Duel.GetAttacker():IsControler(1-tp)
end

function c65071044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return Duel.GetAttacker():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end

function c65071044.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc then Duel.GetControl(tc,tp) end
end