--眼前与远方的世界
function c65030019.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c65030019.accost)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c65030019.aclimit)
	e1:SetCondition(c65030019.actcon)
	c:RegisterEffect(e1)
	--endphase
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65030019.edcon)
	e2:SetTarget(c65030019.edtg)
	e2:SetOperation(c65030019.edop)
	c:RegisterEffect(e2)
end
c65030019.card_code_list={65030020}
function c65030019.costfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsReleasable() and aux.IsCodeListed(c,65030020)
end
function c65030019.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030019.costfil,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65030019.costfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c65030019.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c65030019.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 
end
function c65030019.ntfil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030019.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(c65030019.ntfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 
end
function c65030019.edfil(c)
	return c:GetAttackAnnouncedCount()==0
end
function c65030019.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030019.edfil,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c65030019.edop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(c65030019.edfil,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local check=0
	local i=0
	if num<=0 then return false end
	while check==0 do
		local gc=g:RandomSelect(tp,1):GetFirst()
		g:RemoveCard(gc)
		Duel.Remove(gc,POS_FACEDOWN,REASON_EFFECT)
		i=i+1
		if i==num or not Duel.SelectYesNo(tp,aux.Stringid(65030019,0)) then check=1 end
	end
end
