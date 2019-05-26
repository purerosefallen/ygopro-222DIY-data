local m=33330300
local token={33330321}
local cm=_G["c"..m]
cm.name="THE TRUTH 真理之眼"
--配 置 信 息
cm.draw=1   --抽 卡 数

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion
	aux.AddFusionProcMix(c,false,true,cm.mfilter1,cm.mfilter2,cm.mfilter3)
	--Special Summon Rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--Token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
--Fusion
function cm.mfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(2) and c:IsType(TYPE_TUNER)
end
function cm.mfilter2(c)
	return c:IsRace(RACE_MACHINE)
end
function cm.mfilter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
--Special Summon Rule
function cm.mfilter(c,fc)
	return (cm.mfilter1(c) or cm.mfilter2(c) or cm.mfilter3(c)) and c:IsFaceup()
		and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	return c:CheckFusionMaterial(mg,nil,tp)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp)
	Duel.HintSelection(g)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--Token
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,token[1],0,0x4011,-2,-2,10,RACE_CYBERSE,ATTRIBUTE_LIGHT)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp)<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,token[1],0,0x4011,-2,-2,10,RACE_CYBERSE,ATTRIBUTE_LIGHT)
		or not tc:IsRelateToEffect(e)
		or tc:IsFacedown() then return end
	local tk=Duel.CreateToken(tp,token[1])
	Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tk:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(tc:GetAttack())
	tk:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(tc:GetDefense())
	tk:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetValue(tc:GetCode())
	tk:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.desop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	tk:RegisterEffect(e5,true)
	if tc:IsType(TYPE_EFFECT) then
		--Copy Effect
		tk:CopyEffect(tc:GetCode(),RESET_EVENT+RESETS_STANDARD)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_ADD_TYPE)
		e6:SetValue(TYPE_EFFECT)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6,true)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_REMOVE_TYPE)
		e7:SetValue(TYPE_NORMAL)
		tc:RegisterEffect(e7,true)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--Draw
function cm.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function cm.shuffle(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(tp,cm.draw) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cm.draw)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(cm.shuffle,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if og:IsExists(cm.shuffle,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		Duel.BreakEffect()
		Duel.Draw(tp,cm.draw,REASON_EFFECT)
	end
end