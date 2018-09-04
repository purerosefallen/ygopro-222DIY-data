--愉快的遗忘之伞·多多良小伞
local m=1141001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Tatara=true
--
function c1141001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1141001,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1141001.tg1)
	e1:SetOperation(c1141001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1141001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c1141001.tg2)
	e2:SetOperation(c1141001.op2)
	c:RegisterEffect(e2)
--
end
--
c1141001.muxu_ih_KTatara=1
--
function c1141001.tfilter1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c1141001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and c1141001.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1141001.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and c1141001.tfilter1(c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=Duel.SelectTarget(tp,c1141001.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,2,0,0)
end
--
function c1141001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() then return end
	if tc:IsFacedown() then return end 
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	local sg=Group.FromCards(c,tc)
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
end
--
function c1141001.tfilter2(c,e,tp)
	return ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
		or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()))
		and c.muxu_ih_KTatara 
end
function c1141001.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1141001.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1141001.tfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c1141001.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
--
function c1141001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		if not c:IsRelateToEffect(e) then return end
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end


