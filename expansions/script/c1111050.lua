--景愿『遗暗铭光』
local m=1111050
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Scenersh=true
--
function c1111050.initial_effect(c)
--
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
--
	c1111050.dfc_front_side=1111050
	c1111050.dfc_back_side=1111090
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_DECK)
	e1:SetOperation(c1111050.op1)
	c:RegisterEffect(e1)
--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c1111050.con6)
	e6:SetTarget(c1111050.tg6)
	e6:SetOperation(c1111050.op6)
	c:RegisterEffect(e6)
--
	if not c1111050.chk then
		c1111050.chk=true
		local e7=Effect.GlobalEffect()
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_TO_DECK)
		e7:SetCondition(c1111050.con7)
		e7:SetOperation(c1111050.op7)
		Duel.RegisterEffect(e7,0)
	end
--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c1111050.op8)
	c:RegisterEffect(e8,true)
--
end
--
function c1111050.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsFaceup() and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DECK)
	local b2=c:IsFacedown() and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DECK)
	if c:IsLocation(LOCATION_DECK) and (b1 or b2) then
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
		c:ReverseInDeck()
		Duel.Readjust()
	end
end
--
function c1111050.con6(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1111050.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1111050,nil,0x11,0,0,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1111050.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1111050,nil,0x11,0,0,3,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_FAIRY,3,0,0)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_SINGLE)
	e6_1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e6_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6_1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e6_1:SetValue(LOCATION_DECK)
	c:RegisterEffect(e6_1,true)
	c:RegisterFlagEffect(1111050,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY-RESET_TODECK-RESET_LEAVE,0,0)
	Duel.SpecialSummonComplete()
end
--
function c1111050.cfilter7(c)
	return c:GetFlagEffect(1111050)~=0
end
function c1111050.con7(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111050.cfilter7,1,nil)
end
--
function c1111050.op7(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local tg=eg:Filter(c1111050.cfilter7,nil)
	if tg:GetCount()<1 then return end
	local b1=tg:IsExists(Card.IsControler,1,nil,p)
	local b2=tg:IsExists(Card.IsControler,1,nil,1-p)
	if b1 then Duel.ShuffleDeck(p) end
	if b2 then Duel.ShuffleDeck(1-p) end
	local tc=tg:GetFirst()
	while tc do
		tc:ReverseInDeck()
		tc=tg:GetNext()
	end
end
--
function c1111050.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_MONSTER) then
		Duel.SendtoGrave(c,REASON_RULE)
		Duel.Readjust()
	end
end
--
