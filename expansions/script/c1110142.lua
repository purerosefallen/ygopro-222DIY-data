--灵都·亘古不变的微光
local m=1110142
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110142.initial_effect(c)
--
	aux.EnablePendulumAttribute(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110142,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c1110142.tg1)
	e1:SetOperation(c1110142.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110142,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1110142)
	e2:SetTarget(c1110142.tg2)
	e2:SetOperation(c1110142.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c1110142.con3)
	e3:SetTarget(c1110142.tg3)
	e3:SetOperation(c1110142.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110142.tfilter1(c)
	return (c:IsCode(1110002,1110122)) and c:IsReleasable()
end
function c1110142.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110142.tfilter1(chkc,e,tp) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsExistingTarget(c1110142.tfilter1,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsExistingTarget(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,1110161)>0)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if Duel.GetFlagEffect(tp,1110161)>0 then
		local sg=Duel.SelectTarget(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,1,0,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_PZONE)
	else
		local sg=Duel.SelectTarget(tp,c1110142.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,1,0,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_PZONE)
	end
end
--
function c1110142.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Release(tc,REASON_EFFECT)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--
function c1110142.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1110142.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)<1 then return end
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,p,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(p,aux.Stringid(1110142,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_REMOVED,0,1,3,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
--
function c1110142.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
--
function c1110142.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
--
function c1110142.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT)
end
--
