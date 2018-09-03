--眩耀奇景
function c65030020.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65030020,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65030020.cost)
	e1:SetTarget(c65030020.target)
	e1:SetOperation(c65030020.operation)
	c:RegisterEffect(e1)
	--endphase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65030020,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65030020.edcon)
	e2:SetTarget(c65030020.edtg)
	e2:SetOperation(c65030020.edop)
	c:RegisterEffect(e2)
end
c65030020.card_code_list={65030020}
function c65030020.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c65030020.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 
end
function c65030020.ntfil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030020.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(c65030020.ntfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 
end
function c65030020.edfil(c)
	return c:GetAttackAnnouncedCount()==0 or c:IsAttack(0) 
end
function c65030020.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030020.edfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function c65030020.edop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65030020.edfil,tp,0,LOCATION_MZONE,nil)
	if Duel.GetFieldGroup(tp,0,LOCATION_MZONE)==0 then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	end
	if g:GetCount()>0 then
		local num=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		if num~=0 then
			Duel.BreakEffect()
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500*num)
		end
	end
end
function c65030020.costfil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c65030020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030020.costfil,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65030020.costfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65030020.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,65030020) and not c:IsForbidden() 
end
function c65030020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c65030020.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c65030020.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c65030020.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end