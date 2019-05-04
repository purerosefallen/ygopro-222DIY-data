--柱形魔-司库斯
function c21520174.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c21520174.fsfilter1,c21520174.fsfilter2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520174.splimit)
	c:RegisterEffect(e1)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520174.ccon)
	e00:SetOperation(c21520174.ccost)
	c:RegisterEffect(e00)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520174,3))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c21520174.drcon)
	e4:SetTarget(c21520174.drtg)
	e4:SetOperation(c21520174.drop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520174,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c21520174.spcon)
	e5:SetTarget(c21520174.sptg)
	e5:SetOperation(c21520174.spop)
	c:RegisterEffect(e5)
end
function c21520174.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520174.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520174.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520174.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c21520174.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520174,0),aux.Stringid(21520174,1),aux.Stringid(21520174,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520174,1),aux.Stringid(21520174,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c21520174.fsfilter1(c)
	return c:IsCode(21520164)
end
function c21520174.fsfilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c21520174.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if ct1>=ct2 then return false end
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c21520174.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c21520174.drop(e,tp,eg,ep,ev,re,r,rp)
	local count1=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local count2=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,e:GetHandler())
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,count1,REASON_EFFECT)
	Duel.Draw(1-tp,count2,REASON_EFFECT)
end
function c21520174.spfilter(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c21520174.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c21520174.spfilter2(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c21520174.spfilter3,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c21520174.spfilter3(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c21520174.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
end
function c21520174.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c21520174.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c21520174.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local mg=Duel.GetMatchingGroup(c21520174.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=mg:GetCount()
--	local g2 = c21520174.group_unique_code(mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--	local g1=g2:Select(tp,1,3,nil)
	local g1=mg:Select(tp,1,1,nil)
	if ct>1 and Duel.SelectYesNo(tp,aux.Stringid(21520174,5)) then
		mg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		local g2=mg:Select(tp,1,1,nil)
		g1:Merge(g2)
		if ct>2 and Duel.SelectYesNo(tp,aux.Stringid(21520174,5)) then
			mg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
			local g3=mg:Select(tp,1,1,nil)
			g1:Merge(g3)
		end
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
end
function c21520174.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) 
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
--[[
function c21520174.group_unique_code(g)
	local check={}
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetOriginalCode()}) do
			if not check[code] then
				check[code]=true
				tg:AddCard(tc)
			end
		end
		tc=g:GetNext()
	end
	return tg
end--]]
