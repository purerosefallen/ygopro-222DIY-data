--勝利の法則は負ける気がしねえ!
local m=17092201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()~=2 then return end
	local tc=sg:GetFirst()
	local atk,def=0,0
	while tc do
		atk=atk+tc:GetAttack()
		def=def+tc:GetDefense()
		tc=sg:GetNext()
	end
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=2 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,17092201,nil,0x21,atk,def,7,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESET_LEAVE)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2,true)
		local code1=sg:GetFirst():GetOriginalCode()
		local code2=sg:GetNext():GetOriginalCode()
		c:CopyEffect(code1,RESET_EVENT+RESETS_STANDARD,1)
		c:CopyEffect(code2,RESET_EVENT+RESETS_STANDARD,1)
		Duel.SpecialSummonComplete()
	end
end
