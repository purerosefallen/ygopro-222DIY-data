--
local m=17061158
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side1=m+1
cm.dfc_back_side2=m+2
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	e:SetLabel(op)
	if op==0 then
	local tcode=e:GetHandler().dfc_back_side1
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	else
	local tcode1=e:GetHandler().dfc_back_side2
	e:GetHandler():SetEntityCode(tcode1,true)
	e:GetHandler():ReplaceEffect(tcode1,0,0)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end