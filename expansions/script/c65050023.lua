--残落都市 描绘者
function c65050023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,65050023)
	e1:SetTarget(c65050023.target)
	e1:SetOperation(c65050023.operation)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c65050023.descon)
	e2:SetOperation(c65050023.desop)
	c:RegisterEffect(e2)
	--cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c65050023.limcon)
	e3:SetTarget(c65050023.splimit)
	c:RegisterEffect(e3)
	--CANNOT SUMMON
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c65050023.limitcon1)
	e4:SetTarget(c65050023.limit1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(c65050023.limitcon2)
	e5:SetTarget(c65050023.limit2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetTargetRange(0,1)
	e6:SetCondition(c65050023.limitcon12)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetTargetRange(0,1)
	e7:SetCondition(c65050023.limitcon22)
	c:RegisterEffect(e7)
end
function c65050023.limfil(c)
	return not c:IsType(TYPE_NORMAL)
end
function c65050023.limcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050023.limfil,tp,LOCATION_MZONE,0,nil)==0
end
function c65050023.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_HAND) and not se:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c65050023.limitcon1(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050023.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
function c65050023.limitcon12(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050023.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<1
end
function c65050023.limit1(e,c)
	return c:IsLevelAbove(5)
end
function c65050023.limitcon2(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050023.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2
end
function c65050023.limitcon22(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050023.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<2
end
function c65050023.limit2(e,c)
	return c:IsLevelAbove(7)
end
function c65050023.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65050023.relfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL) and c:IsReleasable()
end
function c65050023.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.IsExistingMatchingCard(c65050023.relfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050023,0)) then
		local g=Duel.SelectMatchingCard(tp,c65050023.relfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function c65050023.filter(c)
	return c:IsSetCard(0xada4) and c:IsAbleToHand()
end
function c65050023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050023.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65050023.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050023.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
