--蝶舞·恋心
local m=1111025
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111025.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111025.tg1)
	e1:SetOperation(c1111025.op1)
	c:RegisterEffect(e1)
end
--
function c1111025.tfilter1(c)
	return c:IsAbleToGrave() 
		and muxu.check_set_Butterfly(c) and c:IsType(TYPE_SPELL)
		and not c:IsCode(1111025)
end
function c1111025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111025.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c1111025.ofilter1(c)
	return c:IsAbleToHand()
		and muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL)
end
function c1111025.tgcheck1(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function c1111025.lfilter1(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c1111025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c1111025.tfilter1,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()<1 then return end
	local ct=mg:GetClassCount(Card.GetCode)
	local cg=Duel.GetMatchingGroup(c1111025.ofilter1,tp,LOCATION_DECK,0,nil)
	if cg:GetCount()<1 then ct=math.min(ct,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,c1111025.tgcheck1,false,1,ct)
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	local num=Duel.GetOperatedGroup():GetCount()
	if num>1 then
		Duel.RegisterFlagEffect(tp,1111025,0,0,0)
		local res=Duel.IsExistingMatchingCard(c1111025.lfilter1,tp,LOCATION_EXTRA,0,1,nil)
		if res and Duel.SelectYesNo(tp,aux.Stringid(1111025,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lg=Duel.SelectMatchingCard(tp,c1111025.lfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SpecialSummonRule(tp,lg:GetFirst(),SUMMON_TYPE_LINK)
		end
		Duel.ResetFlagEffect(tp,1111025)
	end
	if num>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1111025.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1_1:SetTargetRange(0,1)
		e1_1:SetValue(aux.TRUE)
		e1_1:SetCondition(c1111025.con1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	end
end
function c1111025.cfilter1_1(c,tp)
	return c:IsFaceup() and muxu.check_set_Urban(c)
		and c:GetPreviousLocation()~=LOCATION_EXTRA 
		and Duel.IsExistingMatchingCard(c1111025.cfilter1_2,tp,LOCATION_MZONE,0,1,c,c)
end
function c1111025.cfilter1_2(c,tc)
	local att=tc:GetAttribute()
	return c:IsFaceup() and muxu.check_set_Urban(c)
		and c:GetPreviousLocation()~=LOCATION_EXTRA
		and c:IsAttribute(att)
end
function c1111025.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1111025.cfilter1_1,tp,LOCATION_MZONE,0,1,nil,tp)
end
--
