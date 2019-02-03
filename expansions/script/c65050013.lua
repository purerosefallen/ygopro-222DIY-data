--迷失水界的神游
function c65050013.initial_effect(c)
	--contorl
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65050013.tg)
	e1:SetOperation(c65050013.op)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c65050013.con)
	e2:SetTarget(c65050013.tgtg)
	e2:SetOperation(c65050013.tgop)
	c:RegisterEffect(e2)
end
function c65050013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOwner()~=e:GetHandlerPlayer() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65050013.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sp=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,sp)
	end
end
function c65050013.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==c:GetPreviousControler() and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c65050013.thfil(c,e,tp)
	local code=c:GetCode()
	return c:IsSetCard(0xcda3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65050013.thfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,code)
end
function c65050013.thfil2(c,e,tp,code)
	return c:IsSetCard(0xcda3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c65050013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cp=c:GetPreviousControler()
	if chk==0 then return true end
	local num=0
	if cp==tp then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
		num=1
	elseif cp~=tp then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
		num=2
	end
	e:SetLabel(num)
end
function c65050013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local c=e:GetHandler()
	if num==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	elseif num==2 and Duel.IsExistingMatchingCard(c65050013.thfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Duel.SelectMatchingCard(tp,c65050013.thfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local code=g:GetFirst():GetCode()
		local g1=Duel.SelectMatchingCard(tp,c65050013.thfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
		g:Merge(g1)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
