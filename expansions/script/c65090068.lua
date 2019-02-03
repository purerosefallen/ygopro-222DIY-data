--天邪逆鬼的翻覆天地
function c65090068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c65090068.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c65090068.con)
	e2:SetTarget(c65090068.tg)
	e2:SetOperation(c65090068.op)
	c:RegisterEffect(e2)
	 --atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c65090068.val)
	c:RegisterEffect(e3)
end
function c65090068.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9da7) and c:IsAbleToRemove()
end
function c65090068.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c65090068.thfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65090068,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c65090068.confil(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65090068.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65090068.confil,1,nil)
end
function c65090068.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c65090068.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local spg=eg:Filter(c65090068.confil,nil)
	if chk==0 then return spg:FilterCount(c65090068.spfil,nil,e,tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c65090068.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local spg=eg:Filter(c65090068.confil,nil)
	local g=spg:FilterSelect(tp,c65090068.spfil,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65090068.valc(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65090068.val(e,c)
	local tp=e:GetHandler():GetControler()
	local num=Duel.GetMatchingGroupCount(c65090068.valc,tp,LOCATION_REMOVED,0,nil)
	return num*-100
end