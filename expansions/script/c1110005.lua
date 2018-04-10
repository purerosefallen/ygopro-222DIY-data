--命运·时计
local m=1110005
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c1110005.cost1)
	e1:SetTarget(c1110005.tg1)
	e1:SetOperation(c1110005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1110005)
	e2:SetTarget(c1110005.tg2)
	e2:SetOperation(c1110005.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1110005.tfilter1_1(c)
	return c:IsAbleToHand() and muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
end
function c1110005.tfilter1_2(c)
	return c:IsSSetable() and muxu.check_set_Legend(c)
end
function c1110005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1110005.tfilter1_1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c1110005.tfilter1_2,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1110005,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1110005,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	end
end
--
function c1110005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1110005.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c1110005.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--
function c1110005.tfilter2_1(c,e,tp,tc)
	local lv=c:GetLevel()
	local lv2=tc:GetLevel()
	return lv>0 and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c1110005.tfilter2_2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+lv2)
end
function c1110005.tfilter2_2(c,e,tp,lv)
	return muxu.check_set_Urban(c) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c1110005.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingTarget(c1110005.tfilter2_1,tp,LOCATION_GRAVE,0,1,c,e,tp,c) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1110005.tfilter2_1,tp,LOCATION_GRAVE,0,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1110005.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local lv=g:GetFirst():GetLevel()+g:GetNext():GetLevel()
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1110005.tfilter2_2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()<1 then return end
	if Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)<1 then return end
	local sc=sg:GetFirst()
	sc:CompleteProcedure()
end
--

