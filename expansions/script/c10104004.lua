--兹鲁夫咒符-融合
local m=10104004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)	
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   e:SetLabel(0)
	   return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,c)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=e:GetLabelObject()
	local code,race,att=tc:GetOriginalCode(),tc:GetOriginalRace(),tc:GetOriginalAttribute()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,0x21,0,0,1,race,att) then
		c:AddMonsterAttribute(TYPE_EFFECT,att,race,1,0,0)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
	if not tc:IsType(TYPE_FUSION) then return end
	local atk,def,lv=tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalLevel()
	if atk==0 and def==0 and lv==1 and tc:GetOriginalType()&TYPE_EFFECT<=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(lv)
	c:RegisterEffect(e3) 
	c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
end
function cm.rfilter(c,rc)
	if c:GetOriginalType()&TYPE_MONSTER<=0 then return false end
	local code,race,att=c:GetOriginalCode(),c:GetOriginalRace(),c:GetOriginalAttribute()
	return Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,0x21,0,0,1,race,att)
end
function cm.filter(c)
	return c:IsSetCard(0xa330) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
