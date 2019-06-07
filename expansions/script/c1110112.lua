--灵都·葬魂幽蝶
local m=1110112
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110112.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,1110004,c1110112.filter,1,true,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110112,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1110112)
	e1:SetCondition(c1110112.con1)
	e1:SetTarget(c1110112.tg1)
	e1:SetOperation(c1110112.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110112,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1110112)
	e2:SetCondition(c1110112.con2)
	e2:SetTarget(c1110112.tg2)
	e2:SetOperation(c1110112.op1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c1110112.tg3)
	e3:SetOperation(c1110112.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110112.filter(c)
	return c:IsCode(1110002) or c:IsCode(1110122)
end
--
function c1110112.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)~=0 and c:GetMaterialCount()>0 
end
--
function c1110112.tfilter1_1(c,e,tp)
	return muxu.check_set_Urban(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c1110112.tfilter1_2(c)
	return c:IsAbleToDeck() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsPreviousLocation(LOCATION_EXTRA)
end
function c1110112.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1110112.tfilter1_1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c1110112.tfilter1_2,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return (b1 or b2) and Duel.GetFlagEffect(tp,1110004)<1 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1110112,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1110112,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	end
end
--
function c1110112.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1110112.tfilter1_1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()<1 then return end
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_SINGLE)
		e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_3:SetCode(EFFECT_ADD_TYPE)
		e1_3:SetValue(TYPE_SPIRIT)
		e1_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_3,true)
		tc:RegisterFlagEffect(1110112,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1110112,6))
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c1110112.tfilter1_2,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()<1 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function c1110112.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--
function c1110112.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1110112.tfilter1_1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c1110112.tfilter1_2,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return (b1 or b2) and Duel.GetFlagEffect(tp,1110004)>0 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1110112,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1110112,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	end
end
--
function c1110112.tfilter3(c)
	return c:IsCode(1110142) and c:IsAbleToHand()
end
function c1110112.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110112.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1110112.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110112.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--
