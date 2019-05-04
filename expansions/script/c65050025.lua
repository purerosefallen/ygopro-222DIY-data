--残落都市 朝圣者
function c65050025.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
   --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,65050025)
	e1:SetCost(c65050025.cost)
	e1:SetTarget(c65050025.target)
	e1:SetOperation(c65050025.operation)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c65050025.descon)
	e2:SetOperation(c65050025.desop)
	c:RegisterEffect(e2)
	--cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c65050025.limcon)
	e3:SetTarget(c65050025.splimit)
	c:RegisterEffect(e3)
end
function c65050025.limfil(c)
	return not c:IsType(TYPE_NORMAL)
end
function c65050025.limcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050025.limfil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c65050025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT) and (c:IsLevelAbove(5) or not c:IsLevelAbove(1))
end
function c65050025.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65050025.relfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL) and c:IsReleasable()
end
function c65050025.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.IsExistingMatchingCard(c65050025.relfil,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050025,0)) then
		local g=Duel.SelectMatchingCard(tp,c65050025.relfil,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function c65050025.costfil(c)
	return not c:IsPublic()
end
function c65050025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050025.costfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c65050025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c65050025.drfil(c)
	return not (c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER))
end
function c65050025.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c65050025.drfil,tp,LOCATION_HAND,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end